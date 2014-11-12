
CREATE PROCEDURE pr_ranking_conceito_cliente_faturamento
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
---------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
---------------------------------------------------------------------------------------
--Autor(es)      : Carlos Cardoso Fernandes
--Banco de Dados : EGISSQL
--Objetivo       : Consulta do Ranking de Conceito de Cliente - Faturamento
--Data           : 05.06.2006
--Atualizado     : 
---------------------------------------------------------------------------------------
@dt_inicial          datetime,
@dt_final            datetime,
@cd_conceito_cliente int = 0,
@cd_moeda            int = 1,
@cd_tipo_mercado     int = 0 

as

  declare @qt_total_conceito int,
          @vl_total_conceito float,
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

  --select * from cliente_conceito

  -- Seleciona todos os conceitos

  Select 
  	cc.cd_conceito_cliente,
  	cc.nm_conceito_cliente,
  	count(distinct(c.cd_cliente)) as Qtd
  into 
  	#Resumo_Conceito
  from
  	Cliente_Conceito cc
  	left outer join Cliente c on c.cd_conceito_cliente = cc.cd_conceito_cliente
  where
     c.cd_conceito_cliente = case when @cd_conceito_cliente = 0 then c.cd_conceito_cliente else @cd_conceito_cliente end
  group by
     cc.cd_conceito_cliente,
     cc.nm_conceito_cliente

  --Dados da View de Faturamento
  
  Select 
    IsNull(vw.cd_conceito_cliente,0)       as conceito,
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
    count ( distinct vw.cd_cliente  )                              as 'Atendimento',
    count ( distinct vw.cd_vendedor )                              as 'qtdVendedor' 
 
  into 
    #FaturaAnual
  from
    vw_faturamento_bi vw
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto 
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final and
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end    
  group by 
  	IsNull(vw.cd_conceito_cliente,0)
  order by 1 desc
  
  
  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
    IsNull(vw.cd_conceito_cliente,0)       as conceito,
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
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS
   
  into 
    #FaturaDevolucao
  from
    vw_faturamento_devolucao_bi vw
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto 
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final and
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end    
  group by
    IsNull(vw.cd_conceito_cliente,0)
  order by 1 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
    IsNull(vw.cd_conceito_cliente,0)       as conceito,
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
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS
   
  into 
    #FaturaDevolucaoAnoAnterior
  from
    vw_faturamento_devolucao_mes_anterior_bi vw
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto 
  where 
  	(vw.dt_nota_saida < @dt_inicial) and
  	vw.dt_restricao_item_nota between @dt_inicial and @dt_final and
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end    
  group by 
  	IsNull(vw.cd_conceito_cliente,0)
  order by 1 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
    IsNull(vw.cd_conceito_cliente,0) as conceito,
    max(vw.dt_nota_saida)     																																							as UltimaCompra,
    sum(vw.vl_unitario_item_atual) / @vl_moeda 																						as Compra,
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
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS
   
  into 
    #FaturaCancelado
  from
    vw_faturamento_cancelado_bi vw
    left outer join Produto_Custo pc  on vw.cd_produto = pc.cd_produto 
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final and
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end    
  group by 
     IsNull(vw.cd_conceito_cliente,0)
  order by 1 desc


  select a.conceito ,		
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
        a.Atendimento,
        a.qtdVendedor  

  into 
  	#FaturaResultado
  from 
  	#FaturaAnual a
  	left outer join  #FaturaDevolucao b            on a.conceito = b.conceito
        left outer join  #FaturaDevolucaoAnoAnterior c on a.conceito = c.conceito
        left outer join  #FaturaCancelado d            on a.conceito = d.conceito

  set @qt_total_conceito = @@rowcount
  set @vl_total_conceito = 0
  
  Select 
  	@vl_total_conceito = Sum(IsNull(Compra,0))
  from
    #FaturaResultado
  
  --Cria a Tabela Final de Faturas por Setor
  select 
    IDENTITY(int, 1,1) 															as Posicao, 
    a.conceito,                               
    a.Compra                                            as Venda, 
    ((a.Compra/@vl_total_conceito)*100)           	as Perc, 
    a.UltimaCompra																	as UltimaVenda, 
    a.Pedidos             												  as Pedidos,
    a.TotalLiquido,
    a.TotalLista,
   cast((( a.TotalLista / a.Compra ) * 100) - 100 as decimal (15,2)) as 'Descto',
    a.CustoContabil,
    a.MargemContribuicao,
    a.BNS,
    a.Atendimento,
    a.qtdvendedor

  Into 
	#FaturaResultadoFinal
  from 
    #FaturaResultado a
  order by a.Compra desc

  --Mostra tabela ao usuário

  Select 
    r.*, 
    
    c.nm_conceito_cliente,
    c.Qtd                  as QtdClientes,
    participacao = (cast(r.atendimento as float)/case when c.qtd=0 then 1 else c.qtd end)*100

  from 
    #FaturaResultadoFinal r 
    inner join #Resumo_Conceito c on c.cd_conceito_cliente = r.conceito
  order by 
    Posicao asc

