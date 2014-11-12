﻿
CREATE PROCEDURE pr_fatura_setor
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
---------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
---------------------------------------------------------------------------------------
--Autor(es): Daniel Carrasco Neto.
--Banco de Dados: EGISSQL
--Objetivo: Consulta Faturamento por Vendedor.
--Obs: - Baseado na Prodedure homônima: pr_fatura_setor ( SAP)
--Data: 02/08/2002
--Atualizado: 05/11/2002 - Acerto na contagem do número de notas por vendedor
--                       - Acerto de Joins e Filtros que indicam q é nota de saída
-- 06/11/2003 - Incluído filtro por moeda - Daniel c. Neto.
-- 21/11/2003 - Incluído novas colunas e acertado filtro - Daniel C. Neto.
-- 10/12/2003 - Acerto Relacionamento Pedido_Venda_Item - Daniel C. Neto.
-- 23/04/2004 - Acerto no parametro da fn_vl_liquido_venda - ELIAS
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 06.03.2006 - acertos - Carlos Fernandes
-- 14.03.2006 - tipo de mercado/meta - Carlos Fernandes
-- 06.08.2008 - Ajuste do Cancelamento sem item de Nota - Carlos Fernandes
-- 11.05.2010 - Ajuste Devolução - Carlos Fernandes
---------------------------------------------------------------------------------------
@dt_inicial      datetime,
@dt_final        datetime,
@cd_vendedor     int,
@cd_moeda        int = 1,
@cd_tipo_mercado int = 0 

as


  declare @dt_inicio_periodo datetime

  set
      @dt_inicio_periodo = cast( cast(month(@dt_final) as char(02))+'/'+'01'+'/'+cast(year(@dt_final) as char(04)) as datetime )

  set
      @dt_inicio_periodo = convert(datetime,left(convert(varchar,@dt_inicio_periodo,121),10)+' 00:00:00',121)

  declare @qt_total_vendedor int,
          @vl_total_vendedor float,
   	  @ic_devolucao_bi char(1)

  declare @vl_moeda float

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )



  set @ic_devolucao_bi = 'N'
  
  --Define se a empresa trabalha com devoluções do mês anterior
  Select 
  	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
  from 
  	Parametro_BI
  where
  	cd_empresa = dbo.fn_empresa()

  -- Seleciona todos os vendedores

  Select 
    distinct
  	v.cd_vendedor,
  	v.nm_fantasia_vendedor,
  	count(distinct(c.cd_cliente)) as Qtd
  into 
  	#Resumo_Vendedor
  from
  	Vendedor v                with (nolock) 
  	left outer join Cliente c on v.cd_vendedor = c.cd_vendedor
  where
    ( @cd_vendedor = 0 ) or
    ( @cd_vendedor <> 0 and v.cd_vendedor = @cd_vendedor)
  group by
  	v.cd_vendedor, 
  	v.nm_fantasia_vendedor
  

  Select 
  	IsNull(vw.cd_vendedor,0) as cd_vendedor,
  	max(vw.dt_nota_saida)     																																							as UltimaCompra,
    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Compra,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, 
      vw.cd_destinacao_produto, @dt_inicial)) as money) 				as TotalLiquido,
  	sum(vw.vl_unitario_item_total) / @vl_moeda 					as TotalLista,
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, ''))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor) as Vendedor,
    count ( distinct vw.cd_cliente  )                              as 'Atendimento'
 
 
  into 
    #FaturaAnual

  from
    vw_faturamento_bi vw left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto 
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final and
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end and
	vw.cd_vendedor = case when isnull(@cd_vendedor,0) = 0 then vw.cd_vendedor else @cd_vendedor end    
        and vw.cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes  
  group by 
  	IsNull(vw.cd_vendedor,0)
  order by 1 desc
  
  
  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
  	IsNull(vw.cd_vendedor,0) as cd_vendedor,
  	max(vw.dt_nota_saida)     																																							as UltimaCompra,
    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Compra,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, 
      vw.cd_destinacao_produto, @dt_inicial)) as money) 								                                                  as TotalLiquido,
  	sum(vw.vl_unitario_item_total) / @vl_moeda 																						as TotalLista,
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D'))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor) as Vendedor
   
  into 
    #FaturaDevolucao

  from
    vw_faturamento_devolucao_bi vw
    left outer join Produto_Custo pc
    on vw.cd_produto = pc.cd_produto 
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final and
	vw.cd_tipo_mercado          = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end and
	vw.cd_vendedor              = case when isnull(@cd_vendedor,0) = 0 then vw.cd_vendedor else @cd_vendedor end    
        and vw.cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes  

  group by
    IsNull(vw.cd_vendedor,0)
  order by 1 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
    IsNull(vw.cd_vendedor,0) as cd_vendedor,
  	max(vw.dt_nota_saida)     																																							as UltimaCompra,
    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Compra,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, 
      vw.cd_destinacao_produto, @dt_inicial)) as money) 								                                                  as TotalLiquido,
  	sum(vw.vl_unitario_item_total) / @vl_moeda 																						as TotalLista,
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D'))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor) as Vendedor
   
  into 
    #FaturaDevolucaoAnoAnterior

  from
    vw_faturamento_devolucao_mes_anterior_bi vw
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto 

  where 
  	--(vw.dt_nota_saida < @dt_inicial) and
        year(vw.dt_nota_saida) = year(@dt_inicial) and  
        vw.dt_nota_saida < @dt_inicio_periodo and

  	vw.dt_restricao_item_nota between @dt_inicial and @dt_final and
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end and
	vw.cd_vendedor = case when isnull(@cd_vendedor,0) = 0 then vw.cd_vendedor else @cd_vendedor end    
        and vw.cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes  

  group by 
  	IsNull(vw.cd_vendedor,0)
  order by 1 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------

  select 
  	IsNull(vw.cd_vendedor,0) as cd_vendedor,
  	max(vw.dt_nota_saida)     																																							as UltimaCompra,
--    sum(vw.vl_unitario_item_atual) / @vl_moeda 																						as Compra,
    sum(case when isnull(vw.vl_unitario_item_atual,0)>0 then vw.vl_unitario_item_atual else vw.vl_total end) / @vl_moeda 																						as Compra,

    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, vw.vl_ipi, 
      vw.cd_destinacao_produto, @dt_inicial)) as money) 								                                                  as TotalLiquido,
  	sum(vw.vl_unitario_item_total) / @vl_moeda 																						as TotalLista,
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C'))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C')
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor) as Vendedor
   
  into 
    #FaturaCancelado

  from
    vw_faturamento_cancelado_bi vw
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto 

  where 
        year(vw.dt_nota_saida) = 2011 and
  	(vw.dt_nota_saida between @dt_inicial and @dt_final ) and
	vw.cd_tipo_mercado          = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end and
	vw.cd_vendedor              = case when isnull(@cd_vendedor,0) = 0 then vw.cd_vendedor else @cd_vendedor end    
        and vw.cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes  

  group by 
    IsNull(vw.cd_vendedor,0)

  order by 1 desc


  select a.cd_vendedor,		
         a.UltimaCompra, 
         a.Pedidos,

         --Total de Venda
    		 cast(IsNull(a.Compra,0) -
    		 (isnull(b.Compra,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.Compra,0)
  		 			end) + 
  			  isnull(d.Compra,0)) as money) as Compra,

        --Total Líquido
    		cast(IsNull(a.TotalLiquido,0) -
    		 (isnull(b.TotalLiquido,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.TotalLiquido,0)
  		 			end) + 
  			  isnull(d.TotalLiquido,0)) as money) as TotalLiquido,
        --Total de Lista
    		cast(IsNull(a.TotalLista,0) -
    		 (isnull(b.TotalLista,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.TotalLista,0)
  		 			end) + 
  			  isnull(d.TotalLista,0)) as money) as TotalLista,
  			 --Custo Contábil
    		cast(IsNull(a.CustoContabil,0) -
    		 (isnull(b.CustoContabil,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.CustoContabil,0)
  		 			end) + 
  			  isnull(d.CustoContabil,0)) as money) as CustoContabil,
  			 --Margem de Contribuição
  			cast(IsNull(a.MargemContribuicao,0) -
    		 (isnull(b.MargemContribuicao,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.MargemContribuicao,0)
  		 			end) + 
  			  isnull(d.MargemContribuicao,0)) as money) as MargemContribuicao,
  			 --BNS
    		cast(IsNull(a.BNS,0) -
    		 (isnull(b.BNS,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.BNS,0)
  		 			end) + 
  			  isnull(d.BNS,0)) as money) as BNS,
        b.Pedidos as QtdDev,
        c.Pedidos as QtdDevAnt,
        d.Pedidos as QtdCanc,
        dbo.fn_meta_vendedor(a.cd_vendedor,@dt_inicial,@dt_final,0,0) as 'Meta',
        a.Atendimento  

  into 
  	#FaturaResultado

  from 
    #FaturaAnual a 
    left outer join  #FaturaDevolucao b            on a.cd_vendedor = b.cd_vendedor
    left outer join  #FaturaDevolucaoAnoAnterior c on a.cd_vendedor = c.cd_vendedor
    left outer join  #FaturaCancelado d            on a.cd_vendedor = d.cd_vendedor

  set @qt_total_vendedor = @@rowcount
  set @vl_total_vendedor = 0
  
  Select 
  	@vl_total_vendedor = Sum(IsNull(Compra,0))
  from
    #FaturaResultado
  
  --Cria a Tabela Final de Faturas por Setor

  select 
    IDENTITY(int, 1,1) 															as Posicao, 
    a.cd_vendedor      															as Setor, 
    a.Compra        															  as Venda, 
    ((a.Compra/@vl_total_vendedor)*100)           	as Perc, 
    a.UltimaCompra																	as UltimaVenda, 
    a.Pedidos             												  as Pedidos,
    a.TotalLiquido,
    a.TotalLista,
   cast((( a.TotalLista / a.Compra ) * 100) - 100 as decimal (15,2)) as 'Descto',
    a.CustoContabil,
    a.MargemContribuicao,
    a.BNS,
    isnull(a.Meta,0)                          as 'Meta',
    (a.compra / case when a.Meta>0 then a.Meta else 1 end ) * 100 as 'PercMeta',
     a.Atendimento

  Into 
	#FaturaResultadoFinal

  from 
    #FaturaResultado a

  order by a.Compra desc

  --Mostra tabela ao usuário

  Select 
    r.*, 
    isnull(v.nm_fantasia_vendedor,'Sem Definição') as nm_fantasia_vendedor,
    v.Qtd                                          as QtdClientes,
    particpacao = (cast(r.atendimento as float)/case when v.qtd=0 then 1 else v.qtd end)*100

  from 
    #FaturaResultadoFinal r
    left outer join #Resumo_Vendedor v on r.Setor = v.cd_vendedor

  order by 
  	Posicao asc

