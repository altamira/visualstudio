
CREATE PROCEDURE pr_fatura_distribuidor

--pr_venda_distribuidor
---------------------------------------------------
--GBS - Global Business Solution	       2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Fabio Cesar Magalhães
--Banco de Dados: EgisSQL
--Objetivo      : Apresenta um Ranking dos Faturamentos por Distribuidor
--Data          : 22.12.2003
--Atualizado    : 23/04/2004 - Acerto no parametro da fn_vl_liquido_venda - ELIAS
---------------------------------------------------

@dt_inicial datetime,
@dt_final datetime,
@cd_cliente int,
@cd_moeda int = 1 

as

  declare @qt_total_distribuidor int,
          @vl_total_distribuidor float,
  				@ic_devolucao_bi char(1)
  
  set @ic_devolucao_bi = 'N'
  
  Select 
  	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
  from 
  	Parametro_BI
  where
  	cd_empresa = dbo.fn_empresa()

  Select 
  	vw.cd_cliente,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total) * dbo.fn_vl_moeda(@cd_moeda) 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) 								as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) * dbo.fn_vl_moeda(@cd_moeda) 																	as TotalLista,
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, ''))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto * dbo.fn_vl_moeda(@cd_moeda))) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')
         * dbo.fn_vl_moeda(@cd_moeda))) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor) as Vendedor
  into 
    #FaturaAnual
  from
    vw_faturamento_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
      left outer join
    Produto p
      on vw.cd_produto = p.cd_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes
    and exists(Select 'x' from cliente where ic_distribuidor_cliente = 'S' and cd_cliente = vw.cd_cliente)
  group by 
  	vw.cd_cliente
  order by 1 desc


  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
  	vw.cd_cliente,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total) * dbo.fn_vl_moeda(@cd_moeda) 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) 								as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) * dbo.fn_vl_moeda(@cd_moeda) 																						as TotalLista,
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D'))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto * dbo.fn_vl_moeda(@cd_moeda))) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')
         * dbo.fn_vl_moeda(@cd_moeda))) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor) as Vendedor
  into 
    #FaturaDevolucao
  from
    vw_faturamento_devolucao_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
      left outer  join
    Produto p
      on vw.cd_produto = p.cd_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes
    and exists(Select 'x' from cliente where ic_distribuidor_cliente = 'S' and cd_cliente = vw.cd_cliente)
  group by 
    vw.cd_cliente
  order by 1 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
  	vw.cd_cliente,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total) * dbo.fn_vl_moeda(@cd_moeda) 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) 								as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) * dbo.fn_vl_moeda(@cd_moeda) 																	as TotalLista,
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D'))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto * dbo.fn_vl_moeda(@cd_moeda))) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')
         * dbo.fn_vl_moeda(@cd_moeda))) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor) as Vendedor
  into 
    #FaturaDevolucaoAnoAnterior
  from
    vw_faturamento_devolucao_mes_anterior_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto
      left outer join
    Produto p
      on vw.cd_produto = p.cd_produto
  where 
    year(vw.dt_nota_saida) = year(@dt_inicial) and
  	(vw.dt_nota_saida < @dt_inicial) and
  	vw.dt_restricao_item_nota between @dt_inicial and @dt_final
    and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes
    and exists(Select 'x' from cliente where ic_distribuidor_cliente = 'S' and cd_cliente = vw.cd_cliente)
  group by 
  	vw.cd_cliente
  order by 1 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
  	vw.cd_cliente,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_atual) * dbo.fn_vl_moeda(@cd_moeda) 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) * dbo.fn_vl_moeda(@cd_moeda) 																	as TotalLista,
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C'))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto * dbo.fn_vl_moeda(@cd_moeda))) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C')
         * dbo.fn_vl_moeda(@cd_moeda))) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor) as Vendedor
  into 
    #FaturaCancelado
  from
    vw_faturamento_cancelado_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
      left outer join
    Produto p
      on vw.cd_produto = p.cd_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes
    and exists(Select 'x' from cliente where ic_distribuidor_cliente = 'S' and cd_cliente = vw.cd_cliente)
  group by 
    vw.cd_cliente
  order by 1 desc

  select a.cd_cliente,
         a.UltimaVenda, 
         a.Pedidos,
         --Total de Venda
    		 cast(IsNull(a.Venda,0) -
    		 (isnull(b.Venda,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.Venda,0)
  		 			end) + 
  			  isnull(d.Venda,0)) as money) as Venda,
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
         a.Vendedor
  into 
  	#FaturaResultado
  from 
    #FaturaAnual a
    	left outer join  
    #FaturaDevolucao b
  	  on a.cd_cliente = b.cd_cliente
      left outer join  
    #FaturaDevolucaoAnoAnterior c
  	  on a.cd_cliente = c.cd_cliente
      left outer join  
    #FaturaCancelado d
  	  on a.cd_cliente = d.cd_cliente
  
  -- Total de Distribuidores
  set @qt_total_Distribuidor = @@rowcount
  -- Total de Vendas Geral dos Setores
  set @vl_total_distribuidor = 0
  select @vl_total_distribuidor = @vl_total_distribuidor + venda
  from
    #FaturaResultado

  --Cria a Tabela Final de Faturas por Setor
  select 
    IDENTITY(int, 1,1)                    as 'Posicao', 
    cd_cliente, 
    Venda                                 as 'venda', 
    ((Venda/@vl_total_distribuidor)*100)  as 'Perc', 
    UltimaVenda, 
    Pedidos                               as 'pedidos',
    TotalLiquido,
    TotalLista,
    CustoContabil,
    MargemContribuicao,
    BNS
  Into 
  	#FaturaDistribuidorResult
  from 
  	#FaturaResultado
  order by 
  	venda desc

  --Mostra tabela ao usuário
  Select 
  	r.*,
    c.nm_fantasia_cliente 
  From 
  	#FaturaDistribuidorResult r inner join 
    Cliente c on c.cd_cliente = r.cd_cliente
  Order by 
  	Posicao

