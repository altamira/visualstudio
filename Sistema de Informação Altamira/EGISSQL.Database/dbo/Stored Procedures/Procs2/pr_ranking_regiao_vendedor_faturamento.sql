create procedure pr_ranking_regiao_vendedor_faturamento
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server 2000
--Daniel Duela
--Raking de Região x Vendedor
--Data         : 03/12/2003
--Atualizado   : 
-- 17.04.2004  - Alteração no parametro 1, peguei a procedure pr_ranking_produto e alterei
--             - para visualizar por região. Igor Gama.
-- 23.04.2004  - Acerto do parametro da fn_vl_liquidi_venda - ELIAS
-- 26.04.2004  - Ateração de cálculo de valor de lista do produto, estava pegando o mesmo cálculo para o
--               valor da venda, que o correto é pegar o valor original do produto e multiplicar pela
--               quantidade de itens da nota. Igor Gama
-----------------------------------------------------------------------------------
@ic_parametro int,
@dt_inicial   datetime,
@dt_final     datetime,
@cd_regiao    int,
@cd_moeda     int = 1

as

  declare @qt_total_setor int,
          @vl_total_setor float,
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
  	IsNull(vw.cd_vendedor,0) as cd_vendedor,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total / @vl_moeda) 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 										as TotalLista,
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- ELIAS 23/04/2004
    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) /
  			 cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) * 100 		  as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    count(vw.cd_vendedor) as qtd_vendedores,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida
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
  group by 
  	IsNull(vw.cd_vendedor,0)
  order by 1 desc


  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
  	IsNull(vw.cd_vendedor,0) as cd_vendedor,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) 								as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 										as TotalLista,
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- ELIAS 23/04/2004
    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) /
  			 cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) * 100 		  as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    count(vw.cd_vendedor) as qtd_vendedores,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida
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
    and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes
  group by 
    IsNull(vw.cd_vendedor,0)
  order by 1 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
  	IsNull(vw.cd_vendedor,0) as cd_vendedor,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
     -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) 								as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 										as TotalLista,
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- ELIAS 23/04/2004
    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) /
  			 cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) * 100 		  as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    count(vw.cd_vendedor) as qtd_vendedores,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida
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
  group by 
  	IsNull(vw.cd_vendedor,0)
  order by 1 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
  	IsNull(vw.cd_vendedor,0) as cd_vendedor,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_atual) / @vl_moeda 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 										              as TotalLista,
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- ELIAS 23/04/2004
    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) /
  			 cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) * 100 		  as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    count(vw.cd_vendedor) as qtd_vendedores,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida
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
  group by 
    IsNull(vw.cd_vendedor,0)
  order by 1 desc


  select 
    a.cd_vendedor,
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
    a.qtd_vendedores,
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
  	  on a.cd_vendedor = b.cd_vendedor
      left outer join  
    #FaturaDevolucaoAnoAnterior c
  	  on a.cd_vendedor = c.cd_vendedor
      left outer join  
    #FaturaCancelado d
  	  on a.cd_vendedor = d.cd_vendedor
  
  -- Total de produtoes
  set @qt_total_setor = @@rowcount
  
if ( @ic_parametro = 1 ) --Agrupo por região
begin

  -- Total de Vendas Geral dos Setores
  set @vl_total_setor = 0
  
  Select 
    @vl_total_setor = @vl_total_setor + venda
  from
    #FaturaResultado

  --Cria a Tabela Final de Faturas por Setor
  select 
    IDENTITY(int, 1,1)      as 'Posicao',
    IsNull(vr.cd_regiao_venda,0) cd_regiao, 
    Sum(a.qtd_vendedores)     as 'qtd_vendedores',
    Sum(a.venda)              as 'venda', 
    Sum(a.TotalLiquido)       as 'TotalLiquido',
    Sum(a.TotalLista)         as 'TotalLista',
    Sum(a.CustoContabil)      as 'CustoContabil',
    Sum(a.MargemContribuicao) as 'MargemContribuicao',
    Sum(a.BNS)                as 'BNS',
    Sum(((a.venda / @vl_total_setor)*100)) as 'Perc',
    Max(a.UltimaVenda)        as 'UltimaVenda',
    Sum(a.pedidos)            as 'pedidos'
  Into 
    #FaturaSetorAux
  from   
    #FaturaResultado a
      Left Outer Join
    Vendedor_regiao vr
      on IsNull(a.cd_vendedor,0) = IsNull(vr.cd_vendedor,0)
  Group By
    IsNull(vr.cd_regiao_venda,0)
  order by venda desc

  --Mostra tabela ao usuário
  select 
    a.*,
    IsNull(rv.nm_regiao_venda,'(Sem Região)') nm_regiao
  from 
    #FaturaSetorAux a left outer join
    Regiao_Venda rv on IsNull(a.cd_regiao,0) = IsNull(rv.cd_regiao_venda,0)
  order by 
    posicao

end
else
if ( @ic_parametro = 2 ) -- Consulta do Ranking Vendedores por Regiões
begin

  -- Total de Vendas Geral dos Setores
  set @vl_total_setor = 0
  
  Select 
    @vl_total_setor = @vl_total_setor + venda
  from
    #FaturaResultado Inner Join
    Vendedor_regiao vr on vr.cd_regiao_venda = @cd_regiao

  select 
    IDENTITY(int, 1,1) as 'Posicao', 
    a.cd_vendedor, 
    isnull(a.venda,0) as 'venda', 
    isnull(((a.venda/@vl_total_setor)*100),0) as 'Perc', 
    a.UltimaVenda, 
    isnull(a.Pedidos,0) as 'pedidos',
    a.TotalLiquido,
    a.TotalLista,
    a.CustoContabil,
    a.MargemContribuicao,
    a.BNS
  Into 
    #FaturaSetorAux2
  from 
    #FaturaResultado a Inner Join
    Vendedor_regiao vr on IsNull(a.cd_vendedor,0) = IsNull(vr.cd_vendedor,0)
                          and vr.cd_regiao_venda = @cd_regiao        
  order by 
    a.venda desc

  --Mostra tabela ao usuário
  select 
    a.*,
    a.cd_vendedor as Setor, 
    v.nm_fantasia_vendedor,
    (Select count('x') from cliente where cd_vendedor = a.cd_vendedor) as qtdclientes
  from 
    #FaturaSetorAux2 a left outer join
    Vendedor v on IsNull(a.cd_vendedor,0) = IsNull(v.cd_vendedor,0)
  order by 
    posicao
end
else
-----------------------------------------------------------------------------------------
if ( @ic_parametro = 3 )  -- Consulta do Ranking Categorias por Regiões
-----------------------------------------------------------------------------------------
begin

  Select 
  	IsNull(vw.cd_vendedor,0) as cd_vendedor,
    IsNull(vw.cd_categoria_produto,0) as cd_categoria_produto,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 																  as TotalLista,
    cast(sum(vw.qt_item_nota_saida) as money)                                                               as Qtde,    
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- ELIAS 23/04/2004
    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) /
  			 cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) * 100 		  as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    count(vw.cd_vendedor) as qtd_vendedores,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida
  into 
    #FaturaAnual_Categoria
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
  group by 
  	IsNull(vw.cd_vendedor,0),
    IsNull(vw.cd_categoria_produto,0)
  order by 1 desc


  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
  	IsNull(vw.cd_vendedor,0) as cd_vendedor,
    IsNull(vw.cd_categoria_produto,0) as cd_categoria_produto,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 																  as TotalLista,
    cast(sum(vw.qt_item_nota_saida) as money)                                                               as Qtde,    
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- ELIAS 23/04/2004
    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) /
  			 cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.pc_icms, 
                  vw.pc_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) * 100 		  as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    count(vw.cd_vendedor) as qtd_vendedores,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida
  into 
    #FaturaDevolucao_Categoria
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
    and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes
  group by 
    IsNull(vw.cd_vendedor,0),
    IsNull(vw.cd_categoria_produto,0)
  order by 1 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
  	IsNull(vw.cd_vendedor,0) as cd_vendedor,
    IsNull(vw.cd_categoria_produto,0) as cd_categoria_produto,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 																  as TotalLista,
    cast(sum(vw.qt_item_nota_saida) as money)                                                               as Qtde,    
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- ELIAS 23/04/2004
    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) /
  			 cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) * 100 		  as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    count(vw.cd_vendedor) as qtd_vendedores,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida
  into 
    #FaturaDevolucaoAnoAnterior_Categoria
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
  group by 
  	IsNull(vw.cd_vendedor,0),
    IsNull(vw.cd_categoria_produto,0)
  order by 1 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
  	IsNull(vw.cd_vendedor,0) as cd_vendedor,
    IsNull(vw.cd_categoria_produto,0) as cd_categoria_produto,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_atual) / @vl_moeda 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 																  as TotalLista,
    cast(sum(vw.qt_item_nota_saida) as money)                                                               as Qtde,    
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) /
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) * 100 		  as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    count(vw.cd_vendedor) as qtd_vendedores,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida
  into 
    #FaturaCancelado_Categoria
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
  group by 
    IsNull(vw.cd_vendedor,0),
    IsNull(vw.cd_categoria_produto,0)
  order by 1 desc


  select a.cd_vendedor,
         a.cd_categoria_produto,
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
         --Qtde Total de Venda
    		 cast(IsNull(a.Qtde,0) -
    		 (isnull(b.Qtde,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.Qtde,0)
  		 			end) + 
  			  isnull(d.Qtde,0)) as money) as Qtde,
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
         a.qtd_vendedores,
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
  	#FaturaResultado_Categoria
  from 
    #FaturaAnual_Categoria a
    	left outer join  
    #FaturaDevolucao_Categoria b
  	  on a.cd_vendedor = b.cd_vendedor
      and a.cd_categoria_produto = b.cd_categoria_produto
      left outer join  
    #FaturaDevolucaoAnoAnterior_Categoria c
  	  on a.cd_vendedor = c.cd_vendedor
      and a.cd_categoria_produto = c.cd_categoria_produto
      left outer join  
    #FaturaCancelado_Categoria d
  	  on a.cd_vendedor = d.cd_vendedor
      and a.cd_categoria_produto = d.cd_categoria_produto

  -- Total de Vendas Geral dos Setores
  set @vl_total_setor = 0
  
  Select 
    @vl_total_setor = @vl_total_setor + venda
  from
    #FaturaResultado_Categoria Inner Join
    Vendedor_regiao vr on vr.cd_regiao_venda = @cd_regiao

  select 
    IDENTITY(int, 1,1) as 'Posicao', 
    a.cd_categoria_produto , 
    isnull(a.venda,0) as Compra, 
    isnull(((a.venda/@vl_total_setor)*100),0) as 'Perc', 
    Qtde as qtd,
    a.UltimaVenda, 
    isnull(a.Pedidos,0) as 'pedidos',
    a.TotalLiquido,
    a.TotalLista,
    a.CustoContabil,
    a.MargemContribuicao,
    a.BNS
  Into 
    #FaturaSetorAux3
  from 
    #FaturaResultado_Categoria a Inner Join
    Vendedor_regiao vr on IsNull(a.cd_vendedor,0) = IsNull(vr.cd_vendedor,0)
                          and vr.cd_regiao_venda = @cd_regiao
        
  order by 
    a.venda desc

  --Mostra tabela ao usuário
    select 
      a.*,
      b.nm_categoria_produto as Categoria
    from 
      #FaturaSetorAux3 a      
      left outer join Categoria_Produto b 
      on a.cd_categoria_produto = b.cd_categoria_produto
    order by 
      posicao

end
