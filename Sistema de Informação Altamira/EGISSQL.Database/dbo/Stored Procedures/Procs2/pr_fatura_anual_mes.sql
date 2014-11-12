
CREATE PROCEDURE pr_fatura_anual_mes
--------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                               2002                     
--------------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes / Lucio        
--Faturas Anuais (Mes a Mes)
--Data          : 11.08.2000
--Atualizado    : 12.08.2000
--              : 26.10.2000 - Lucio : Incluida a linha "set nocount on" 
--                06.04.2002 - Migração p/ Banco EGISSQL
--              : 01.08.2002 - Duela
--              : 23.04.2004 - Inclusão de campo, TotalLiquido - Igor Gama
--                23/04/2004 - Acerto no Parametro da fn_vl_liquido_venda - ELIAS
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
--             : 15.11.2006 - Meta/Ating. Busca da Tabela de Meta_Faturamento - Carlos Fernandes
-- 02.11.2007 - Saldo em Carteira - Carlos Fernandes
-- 27.12.2007 - Saldo em Carteira por Data de Entrega- Carlos Fernandes
-- 09.08.2008 - Nota Fiscal Cancelada - Carlos Fernandes
-- 12.04.2010 - Ajuste para Conversão pelo Dolar - Carlos Fernandes

-------------------------------------------------------------------------------------------------
@cd_ano   int = 0,
@cd_moeda int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


  ----------------------------------------------------
  -- Linha abaixo incluída para rodar no ASP
  ----------------------------------------------------
  set nocount on

  declare 
    @ic_devolucao_bi char(1),
    @vl_total_vendas float,
    @dt_inicial      DateTime

  declare @ic_tipo_conversao_moeda char(1)


  set @ic_devolucao_bi = 'N'
  
  Select 
  	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N'),
              @ic_tipo_conversao_moeda  = isNull(ic_tipo_conversao_moeda,'U')

  from 
  	Parametro_BI with (nolock) 
  where
  	cd_empresa = dbo.fn_empresa()

  Select 
    month(vw.dt_nota_saida)   																	as 'NumeroMes',
    max(vw.dt_nota_saida)     																	as 'Data',
    sum(vw.vl_unitario_item_total
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                  as 'Vendas',
    -- ELIAS 23/04/2004
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto,
                                 cast(str(month(vw.dt_nota_saida)) + '-01-' + str(IsNull(@cd_ano, year(getdate()))) as dateTime))
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                        as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                           as  'Pedidos',

    TotalCarteira = 
    ( select sum (case when isnull(qt_saldo_pedido_venda,0)>0 then
          qt_saldo_pedido_venda * vl_unitario_item_pedido 
          --qt_item_pedido_venda * vl_unitario_item_pedido / @vl_moeda
         else 0 end 
         /
         @vl_moeda)

      from 
        vw_venda_bi with(nolock)
      where
        year(dt_entrega_vendas_pedido) = @cd_ano and
        month(dt_entrega_vendas_pedido) = month(vw.dt_nota_saida))

  into 
    #FaturaAnual

  from
    vw_faturamento_bi vw

  where 
  	year(vw.dt_nota_saida) = @cd_ano    

  group by 

    month(vw.dt_nota_saida)

  order by 1 desc


  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
  	month(vw.dt_nota_saida)   																	as 'NumeroMes',
  	max(vw.dt_nota_saida)     																	as 'Data',
    sum(vw.vl_unitario_item_total
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                         as 'Vendas',
    -- ELIAS 23/04/2004
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto,
                                 cast(str(month(vw.dt_nota_saida)) + '-01-' + str(IsNull(@cd_ano, year(getdate()))) as dateTime))
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                        as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                           as 'Pedidos'
  into 
    #FaturaDevolucao
  from
    vw_faturamento_devolucao_bi vw
  where 
  	year(vw.dt_nota_saida) = @cd_ano
  group by 
    month(vw.dt_nota_saida)
  order by 1 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
    --month(vw.dt_nota_saida)                                     as 'NumeroMes',
    month(vw.dt_restricao_item_nota)                              as 'NumeroMes',
--    max(vw.dt_nota_saida)                                         as 'Data',
    max(vw.dt_restricao_item_nota)                                as 'Data',

    sum(vw.vl_unitario_item_total
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                        as 'Vendas',
-- 	sum(case when isnull(vw.vl_unitario_item_total,0)>0 then vw.vl_unitario_item_total else vw.vl_total end) / @vl_moeda as 'Vendas',

    -- ELIAS 23/04/2004
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto,
                                 cast(str(month(dt_restricao_item_nota)) + '-01-' + str(IsNull(@cd_ano, year(getdate()))) as dateTime))
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                        as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                           as 'Pedidos'

  into 
    #FaturaDevolucaoAnoAnterior

  from
    vw_faturamento_devolucao_mes_anterior_bi vw

  where 
    year(vw.dt_nota_saida) = (@cd_ano - 1)    and
    year(vw.dt_restricao_item_nota) = @cd_ano 

   --month(vw.dt_restricao_item_nota) = month(vw.dt_nota_saida) 


  group by 
    month(dt_restricao_item_nota)

  order by 1 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
  	month(vw.dt_nota_saida)   																	as 'NumeroMes',
  	max(vw.dt_nota_saida)     																	as 'Data',
--    sum(vw.vl_unitario_item_atual) / @vl_moeda as 'Vendas',

    sum(case when isnull(vw.vl_unitario_item_atual,0)>0 then vw.vl_unitario_item_atual else vw.vl_total end
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                        as 'Vendas',
    -- ELIAS 23/04/2004
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto,
                                 cast(str(month(vw.dt_nota_saida)) + '-01-' + str(IsNull(@cd_ano, year(getdate()))) as dateTime))
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                        as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                           as 'Pedidos'
  into 
    #FaturaCancelado

  from
    vw_faturamento_cancelado_bi vw

  where 
  	year(vw.dt_nota_saida) = @cd_ano    
  group by 
    month(vw.dt_nota_saida)
  order by 1 desc


  select 
    a.NumeroMes,
    a.Data,
    a.Pedidos,
    cast(IsNull(a.vendas,0) -
      (isnull(b.vendas,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.vendas,0)
    		end) + 
      isnull(d.vendas,0)) as money) as Vendas,
    cast(IsNull(a.TotalLiquido,0) -
      (isnull(b.TotalLiquido,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.TotalLiquido,0)
    		end) + 
      isnull(d.TotalLiquido,0)) as money) as TotalLiquido,
     a.TotalCarteira  
  into 
  	#FaturaResultado
  from 
    #FaturaAnual a
      left outer join  
    #FaturaDevolucao b
  	  on a.NumeroMes = b.NumeroMes
      left outer join  
    #FaturaDevolucaoAnoAnterior c
  	  on a.NumeroMes = c.NumeroMes
      left outer join  
    #FaturaCancelado d
  	  on a.NumeroMes = d.NumeroMes

  Select  
  	@vl_total_vendas = sum(IsNull(vendas,0))
  From
  	#FaturaResultado

  ----------------------------------------------------
  --Meta do Mês Categoria
  ----------------------------------------------------
  select month(a.dt_inicial_meta_categoria) as 'NumeroMes',
         sum(a.vl_fat_meta_categoria )      as 'MetaMes' 
  into #MetaAnualMesCategoria
  from
    Meta_Categoria_Produto a
  WHERE
    year(a.dt_inicial_meta_categoria) = @cd_ano  
  Group by month(a.dt_inicial_meta_categoria)

  ----------------------------------------------------
  --Meta do Mês Geral
  ----------------------------------------------------
  --select * from meta_faturamento

  select month(a.dt_ini_meta_faturamento)       as 'NumeroMes',
         sum(isnull(a.vl_meta_faturamento,0) )  as 'MetaMes' 
  into #MetaAnualMes
  from
    Meta_Faturamento a
  WHERE
    year(a.dt_fim_meta_faturamento) = @cd_ano  
  Group by 
    month(a.dt_ini_meta_faturamento)


  -- Mostra a Tabela com dados do Mês

  select  
    a.NumeroMes, 
    DateName(month,a.Data)              as Mes, 
    a.Vendas,
    a.TotalLiquido,
    (a.Vendas / @vl_total_vendas) * 100 as Perc,
    a.Pedidos,
    b.MetaMes,
    (a.vendas / b.MetaMes) * 100        as Ating,
    a.TotalCarteira
  from
   	#FaturaResultado a 
  	  left outer join 
    #MetaAnualMes b
    	on a.NumeroMes = b.NumeroMes
  Order by 1 desc

  ----------------------------------------------------
  -- Linha abaixo incluída para rodar no ASP
  ----------------------------------------------------
  set nocount off

