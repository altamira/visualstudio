
CREATE  procedure pr_fatura_grupo_produto
-----------------------------------------------------------------------------------
--GBS - Global Business Sollution                                              2002
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
-----------------------------------------------------------------------------------
--Autor    : Daniel C. Neto
--Objetivo : Faturas de Setores por Grupo
--Criado   : 04/09/2002
--         : 05/11/2003 - Inclusão de consulta por moeda.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
--
-----------------------------------------------------------------------------------
@cd_grupo_produto int,
@dt_inicial       datetime = '',
@dt_final         datetime = '',
@cd_moeda         int = 1

as

  declare @qt_total_produto int,
          @vl_total_produto float,
  				@ic_devolucao_bi char(1)

  declare @vl_moeda float

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )

  set @ic_devolucao_bi = 'N'

  Select 
  	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
  from 
  	Parametro_BI
  where
  	cd_empresa = dbo.fn_empresa()

  Select 
  	vw.cd_grupo_produto,
  	max(vw.dt_nota_saida)                                 as UltimaVenda,
    count(distinct(vw.cd_nota_saida))                         as Pedidos,

    --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004

    sum(vw.vl_unitario_item_total)                            as Venda,
    --sum(vw.vl_unitario_item_total-vw.vl_ipi)                  as VendasemIPI,
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, 
        vw.cd_destinacao_produto, @dt_inicial))               as TotalLiquido,
  	sum(vw.qt_item_nota_saida * p.vl_produto) / @vl_moeda as TotalLista,

    sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda))
                                                               as CustoContabil,

    sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) /
     --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
        vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) * 100 
                                                               as MargemContribuicao,
    sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) * dbo.fn_pc_bns() 
                                                               as BNS,
    count(distinct vw.cd_cliente)                              as Clientes,
    sum(vw.qt_item_nota_saida)                                 as qt_item_nota_saida
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
    and (vw.cd_grupo_produto = @cd_grupo_produto or @cd_grupo_produto = 0)
  group by 
  	vw.cd_grupo_produto
  order by 1 desc

  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
  	vw.cd_grupo_produto,
  	max(vw.dt_nota_saida) as UltimaVenda,
    count(distinct(vw.cd_nota_saida)) as Pedidos,
    --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
    sum(vw.vl_unitario_item_total) as Venda,
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
        vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as TotalLiquido,
  	sum(vw.qt_item_nota_saida * p.vl_produto) / @vl_moeda as TotalLista,
    sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as CustoContabil,
    sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) /
         --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
  			 sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial))  * 100 as MargemContribuicao,
  	sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) * dbo.fn_pc_bns() as BNS,
    count(distinct vw.cd_cliente) as Clientes,
    sum(vw.qt_item_nota_saida) as qt_item_nota_saida
  into 
    #FaturaDevolucao
  from
    vw_faturamento_devolucao_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
      left outer join
    Produto p
      on vw.cd_produto = p.cd_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and (vw.cd_grupo_produto = @cd_grupo_produto or @cd_grupo_produto = 0)
  group by 
    vw.cd_grupo_produto
  order by 1 desc
  
  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
  	vw.cd_grupo_produto,
  	max(vw.dt_nota_saida) as UltimaVenda,
    count(distinct(vw.cd_nota_saida)) as Pedidos,
    --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
    sum(vw.vl_unitario_item_total) as Venda,
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
        vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda as TotalLista,
    sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as CustoContabil,
    sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) /
         --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
  			 sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) * 100 as MargemContribuicao,
  	sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) * dbo.fn_pc_bns() as BNS,
    count(distinct vw.cd_cliente) as Clientes,
    sum(vw.qt_item_nota_saida) as qt_item_nota_saida
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
    and (vw.cd_grupo_produto = @cd_grupo_produto or @cd_grupo_produto = 0)
  group by 
  	vw.cd_grupo_produto
  order by 1 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
  	vw.cd_grupo_produto,
  	max(vw.dt_nota_saida) as UltimaVenda,
    count(distinct(vw.cd_nota_saida)) as Pedidos,
    --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
    sum(vw.vl_unitario_item_atual) as Venda,
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
        vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda as TotalLista,
    sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as CustoContabil,
    sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) /
         --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
  			 sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) * 100 as MargemContribuicao,
  	sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) * dbo.fn_pc_bns()	as BNS,
    count(distinct vw.cd_cliente) as Clientes,
    sum(vw.qt_item_nota_saida) as qt_item_nota_saida
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
    and (vw.cd_grupo_produto = @cd_grupo_produto or @cd_grupo_produto = 0)
  group by 
    vw.cd_grupo_produto
  order by 1 desc

  select 
    a.cd_grupo_produto,
    a.UltimaVenda, 
    a.Pedidos,
    --Total Venda
    cast(IsNull(a.Venda,0) -
      (isnull(b.Venda,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    			when 'N' then 0
    			else isnull(c.Venda,0)
    			end) + 
      isnull(d.Venda,0)) as money) as Venda,
    --Total Liquido
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
    a.Clientes,
    --Quantidade
    cast(IsNull(a.qt_item_nota_saida,0) -
      (isnull(b.qt_item_nota_saida,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    			   when 'N' then 0
    			   else isnull(c.qt_item_nota_saida,0)
    			 end) + 
      isnull(d.qt_item_nota_saida,0)) as money) as Qtd
  into 
    #FaturaResultado
  from 
    #FaturaAnual a
      left outer join  
    #FaturaDevolucao b
    	on a.cd_grupo_produto = b.cd_grupo_produto
      left outer join  
    #FaturaDevolucaoAnoAnterior c
    	on a.cd_grupo_produto = c.cd_grupo_produto
      left outer join  
    #FaturaCancelado d
    	on a.cd_grupo_produto = d.cd_grupo_produto
  
  -- Total de produtoes
  set @qt_total_produto = @@rowcount
  
  -- Total de Vendas Geral dos Setores
  set @vl_total_produto = 0

  Select 
    @vl_total_produto = @vl_total_produto + venda
  from
    #FaturaResultado
  
  --Cria a Tabela Final de Vendas por Setor  
  select 
    IDENTITY(int, 1,1) AS 'Posicao',  
    a.qtd,  
    a.venda,   
    a.TotalLiquido,
    (a.venda/@vl_total_produto)*100 as 'Perc',   
    a.UltimaVenda,   
    a.pedidos,  
    a.Clientes,
    a.TotalLista,  
    a.CustoContabil,  
    a.MargemContribuicao,  
    a.BNS,
    a.cd_grupo_produto as GrupoProduto,
    (case when (a.Venda = 0) or (a.Venda = 0) then 0
    else (100 - (a.Venda * 100)/a.Venda)  end ) as 'Desc' 
  Into 
    #FaturaCategoriaAux
  from 
    #FaturaResultado a  
  Order by 
    a.Venda desc  
   
  --Mostra tabela ao usuário  
  select 
    b.nm_fantasia_grupo_produto,
    b.cd_mascara_grupo_produto,  
    b.nm_grupo_produto,  
    a.*
  from   
    #FaturaCategoriaAux a
      Left Outer Join
    Grupo_Produto b 
      on a.GrupoProduto = b.cd_grupo_produto
  order by posicao  

