
create procedure pr_diario_faturamento

-------------------------------------------------------------------------------
--pr_diario_faturamento
-------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                  	                   2004
-------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Igor Gama
--Banco de Dados	: EGISSQL
--Objetivo		: Diário de Faturamento
--Data		        : 28.04.2004
--Alteração             : 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--                        - Daniel C. Neto.
--                      : 13/12/2004 - Acerto no Cabeçalho - Sérgio Cardoso
--                      : 16/04/2007 - Totais - Carlos Fernandes
--                      : 25.09.2007 - Verificação de Quantidade e Valor - Carlos Fernandes
-- 09.04.2008 - Segmento de Mercado - Carlos Fernandes
-- 24.05.2010 - Devoluções no Período - Carlos Fernandes
--------------------------------------------------------------------------------------------
@dt_base         datetime,
@cd_vendedor     int = 0,
@dt_final        datetime,
@cd_moeda        int = 1,
@cd_tipo_mercado int = 0

as

  declare @dt_inicio_periodo datetime

  set
      @dt_inicio_periodo = cast( cast(month(@dt_final) as char(02))+'/'+'01'+'/'+cast(year(@dt_final) as char(04)) as datetime )

  set
      @dt_inicio_periodo = convert(datetime,left(convert(varchar,@dt_inicio_periodo,121),10)+' 00:00:00',121)


  declare @qt_total_produto int,
          @vl_total_produto float,
          @ic_devolucao_bi  char(1)

  declare @vl_moeda float

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )

  
  set @ic_devolucao_bi = 'N'
  
  set @cd_vendedor = isnull(@cd_vendedor, 0)
  set @dt_final    = isnull(@dt_final, @dt_base)

  Select top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
  from 
    Parametro_BI with (nolock) 
  where	
    cd_empresa = dbo.fn_empresa()
  
  Select 
    vw.cd_nota_saida,
    vw.cd_cliente,
    vw.qt_item_nota_saida as 'Qtd',
    vw.dt_nota_saida      as 'Data',
    vw.cd_produto,
    vw.cd_categoria_produto,
    vw.cd_vendedor,
    vw.vl_unitario_item_total / @vl_moeda                              as 'ValorTotal',
    cast(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
              vw.vl_ipi, vw.cd_destinacao_produto, @dt_base) as float) as 'TotalLiquido',
    vw.cd_condicao_pagamento,
    vw.dt_saida_nota_saida                                             as 'DataSaida',
    vw.nm_ramo_atividade
   into 
     #FaturaAnual
   from
     vw_faturamento_bi vw
   where 
    vw.dt_nota_saida between @dt_base and @dt_final
    and (vw.cd_vendedor = @cd_vendedor or @cd_vendedor = 0) and
    isnull(vw.cd_tipo_mercado,0) = ( case isnull(@cd_tipo_mercado,0) when 0 then isnull(vw.cd_tipo_mercado,0) else isnull(@cd_tipo_mercado,0) end) 
  order by 1, 2, 5, 6, 9 desc

  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------

  select 
    vw.cd_nota_saida,
    vw.cd_cliente,
    vw.qt_item_nota_saida as 'Qtd',
    vw.dt_nota_saida      as 'Data',
    vw.cd_produto,
    vw.cd_categoria_produto,
    vw.cd_vendedor,
    vw.vl_unitario_item_total / @vl_moeda                    as 'ValorTotal',
    cast(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
    vw.vl_ipi, vw.cd_destinacao_produto, @dt_base) as float) as 'TotalLiquido',
    vw.cd_condicao_pagamento,
    vw.dt_saida_nota_saida                                   as 'DataSaida',
    vw.nm_ramo_atividade

  into 
    #FaturaDevolucao

  from
    vw_faturamento_devolucao_bi vw
  where 
  	vw.dt_nota_saida between @dt_base and @dt_final
    and (vw.cd_vendedor = @cd_vendedor or @cd_vendedor = 0)and
    isnull(vw.cd_tipo_mercado,0) = ( case isnull(@cd_tipo_mercado,0) when 0 then isnull(vw.cd_tipo_mercado,0) else isnull(@cd_tipo_mercado,0) end) 
  order by 1, 2, 5, 6, 9 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------

  select 
    vw.cd_nota_saida,
    vw.cd_cliente,
    vw.qt_item_nota_saida as 'Qtd',
    vw.dt_nota_saida      as 'Data',
    vw.cd_produto,
   vw.cd_categoria_produto,
    vw.cd_vendedor,
    vw.vl_unitario_item_total / @vl_moeda as 'ValorTotal',
    cast(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_base) as float) as 'TotalLiquido',
    vw.cd_condicao_pagamento,
    vw.dt_saida_nota_saida as 'DataSaida',
    vw.nm_ramo_atividade

  into 
    #FaturaDevolucaoAnoAnterior
  from
    vw_faturamento_devolucao_mes_anterior_bi vw
  where 

    year(vw.dt_nota_saida) = year(@dt_base) and
   vw.dt_nota_saida < @dt_inicio_periodo and
  	--(vw.dt_nota_saida < @dt_base) and
  	vw.dt_restricao_item_nota between @dt_base and @dt_final
    and (vw.cd_vendedor = @cd_vendedor or @cd_vendedor = 0) and
    isnull(vw.cd_tipo_mercado,0) = ( case isnull(@cd_tipo_mercado,0) when 0 then isnull(vw.cd_tipo_mercado,0) else isnull(@cd_tipo_mercado,0) end) 
    and vw.cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes  

  order by 1, 2, 5, 6, 9 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
    vw.cd_nota_saida,
  	vw.cd_cliente,
    vw.qt_item_nota_saida as 'Qtd',
  	vw.dt_nota_saida as 'Data',
    vw.cd_produto,
   vw.cd_categoria_produto,
    vw.cd_vendedor,
    vw.vl_unitario_item_atual / @vl_moeda as 'ValorTotal',
    cast(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_base) as float) as 'TotalLiquido',
    vw.cd_condicao_pagamento,
    vw.dt_saida_nota_saida as 'DataSaida',
    vw.nm_ramo_atividade

  into 
    #FaturaCancelado
  from
    vw_faturamento_cancelado_bi vw
  where 
  	vw.dt_nota_saida between @dt_base and @dt_final
    and (vw.cd_vendedor = @cd_vendedor or @cd_vendedor = 0)  and
    isnull(vw.cd_tipo_mercado,0) = ( case isnull(@cd_tipo_mercado,0) when 0 then isnull(vw.cd_tipo_mercado,0) else isnull(@cd_tipo_mercado,0) end) 
  order by 1, 2, 5, 6, 9 desc

  select 
    a.cd_nota_saida,
  	a.cd_cliente,
  	a.Data,
    a.cd_produto,
   a.cd_categoria_produto,
    a.cd_vendedor,
    a.cd_condicao_pagamento,
    a.DataSaida,
    --Total de Venda
    cast(IsNull(a.ValorTotal,0) -
    (isnull(b.ValorTotal,0) + 
    		--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.ValorTotal,0)
    		end) + 
    isnull(d.ValorTotal,0)) as money) as 'ValorTotal',
    --Total Líquido
    cast(IsNull(a.TotalLiquido,0) -
     (isnull(b.TotalLiquido,0) + 
    			--Verifica o parametro do BI
    		(case @ic_devolucao_bi
    			when 'N' then 0
    			else isnull(c.TotalLiquido,0)
    			end) + 
      isnull(d.TotalLiquido,0)) as money) as 'TotalLiquido',
    --Quantidade
    cast(IsNull(a.qtd,0) -
        (isnull(b.qtd,0) + 
    			--Verifica o parametro do BI
    		(case @ic_devolucao_bi
    			   when 'N' then 0
    			   else isnull(c.qtd,0)
    			 end) + 
    isnull(d.qtd,0)) as money) as 'Qtd',
    a.nm_ramo_atividade

  into 
  	#FaturaResultado
  from 
    #FaturaAnual a
    	left outer join  
    #FaturaDevolucao b
  	  on a.cd_nota_saida = b.cd_nota_saida and
   	     a.cd_cliente = b.cd_cliente and
         a.cd_produto = b.cd_produto and
         a.cd_vendedor = b.cd_vendedor and
         a.cd_condicao_pagamento = b.cd_condicao_pagamento
      left outer join  
    #FaturaDevolucaoAnoAnterior c
  	  on a.cd_nota_saida = c.cd_nota_saida and
  	     a.cd_cliente = c.cd_cliente and
         a.cd_produto = c.cd_produto and
         a.cd_vendedor = c.cd_vendedor and
         a.cd_condicao_pagamento = c.cd_condicao_pagamento
      left outer join  
    #FaturaCancelado d
  	  on a.cd_nota_saida = d.cd_nota_saida and
  	     a.cd_cliente = d.cd_cliente and
         a.cd_produto = d.cd_produto and
         a.cd_vendedor = d.cd_vendedor and
         a.cd_condicao_pagamento = d.cd_condicao_pagamento
  

--   -- Total de produtoes
--   set @qt_total_produto = @@rowcount
--   
--   -- Total de Vendas Geral dos Setores
--   set @vl_total_produto = 0
-- 
--   Select 
--     @vl_total_produto = @vl_total_produto + venda
--   from
--     #FaturaResultado
    
  --Cria a Tabela Final de Vendas por Setor  

  select 
    a.cd_cliente,
    b.nm_fantasia_cliente   as 'Cliente',
    a.qtd                   as 'qtd',
    a.data                  as 'data',
    a.cd_produto,
    d.nm_categoria_produto  as 'Produto',
    a.cd_vendedor,
    f.nm_fantasia_vendedor  as 'Vendedor',
    a.ValorTotal            as 'ValorTotal',
    a.TotalLiquido          as 'TotalLiquido',
    a.cd_condicao_pagamento,
    e.nm_condicao_pagamento as 'CondicaoPagamento',
    a.DataSaida             as 'DataSaida',
--     (a.venda/@vl_total_produto)*100 as 'Perc',   
--     (case when (a.TotalLiquido = 0) or (a.TotalLista = 0) then 0
--           else (100 - (a.TotalLiquido * 100)/a.TotalLista)  end ) as 'Desc' 
   a.nm_ramo_atividade

  Into 
    #FaturaCategoriaAux
  from 
    #FaturaResultado a
      left outer join
    Cliente b
      on a.cd_cliente = b.cd_cliente
--       left outer join
--     Produto c
--       on a.cd_produto = c.cd_produto
     left outer join
   Categoria_Produto d
     on d.cd_categoria_produto = a.cd_categoria_produto
      left outer join
    Condicao_pagamento e
      on a.cd_condicao_pagamento = e.cd_condicao_pagamento
      left outer join
    Vendedor f
      on a.cd_vendedor = f.cd_vendedor
   where    isnull(b.cd_tipo_mercado,0) = ( case isnull(@cd_tipo_mercado,0) when 0 then isnull(b.cd_tipo_mercado,0) else isnull(@cd_tipo_mercado,0) end) 
--   Group by
--   	a.cd_cliente,
--     b.nm_fantasia_cliente,
--     a.cd_produto,
--     d.nm_categoria_produto,
--     a.cd_vendedor,
--     f.nm_fantasia_vendedor,
--     a.cd_condicao_pagamento,
--     e.nm_condicao_pagamento
  Order by 
--      a.cd_produto
    a.ValorTotal desc  
   
  --Mostra tabela ao usuário  
  select 
    * 
  from 
    #FaturaCategoriaAux
  where 
    isnull(qtd,0)>0
  

