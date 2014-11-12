
CREATE PROCEDURE pr_cpv_nacional
--------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                               2002                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Autor : Igor Gama
--Objetivo : Cálculo do custo do produto
--Data          : 18.05.2004
--------------------------------------------------------------------------------------
@dt_inicial datetime,
@dt_final datetime,
@cd_grupo_produto int,
@cd_produto int,
@cd_fase_produto int,
@ic_analise char(1) = 'A'
as

  declare 
    @ic_devolucao_bi char(1),
    @vl_total_cpv float,
    @vl_total_faturada float

  set @ic_devolucao_bi = 'N'
  set @ic_analise = isnull(@ic_analise,'A')
  
  Select 
  	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
  from 
  	Parametro_BI
  where
  	cd_empresa = dbo.fn_empresa()

  Select 
    vw.cd_produto,
    qt_cpv = Sum(isnull(nfe.qt_item_nota_entrada,0)) + Sum(isnull(pf.qt_atual_prod_fechamento,0)) - sum(vw.qt_item_nota_saida),
    vl_cpv = Sum(isnull(nfe.vl_total_nota_entrada,0) * isnull(nfe.qt_item_nota_entrada,0)) + 
             Sum(isnull(pf.vl_custo_prod_fechamento,0) * isnull(pf.qt_atual_prod_fechamento,0)) - 
             sum(vw.vl_unitario_item_total),
    Sum(isnull(nfe.qt_item_nota_entrada,0)) qt_nota_entrada,
    Sum(isnull(nfe.vl_total_nota_entrada,0) * isnull(nfe.qt_item_nota_entrada,0)) vl_nota_entrada,
    Sum(isnull(pf.qt_atual_prod_fechamento,0)) qt_estoque,
    Sum(isnull(pf.vl_custo_prod_fechamento,0) * isnull(pf.qt_atual_prod_fechamento,0)) vl_estoque,
    sum(vw.qt_item_nota_saida) qt_faturada,
    sum(vw.vl_unitario_item_total) vl_faturada
  into 
    #FaturaAnual
  from
    vw_faturamento_bi vw
      left outer join
    (select cd_produto, sum(qt_item_nota_entrada) qt_item_nota_entrada, sum(qt_item_nota_entrada * vl_item_nota_entrada) vl_total_nota_entrada
     from nota_entrada_item
     where cd_nota_entrada in(select cd_nota_entrada from nota_entrada 
                              where dt_nota_entrada between @dt_inicial and @dt_final)
           and cd_produto is not null
     group by cd_produto) nfe
      on vw.cd_produto = nfe.cd_produto
      left outer join
    (select cd_produto, cd_fase_produto, qt_atual_prod_fechamento, vl_custo_prod_fechamento
     from produto_fechamento 
     where year(dt_produto_fechamento) =
           case when month(@dt_inicial) = 1 then year(dt_produto_fechamento) - 1
                else year(dt_produto_fechamento) end and
           month(dt_produto_fechamento) = month(@dt_inicial) - 1) pf
      on vw.cd_produto = pf.cd_produto and
         vw.cd_fase_produto = pf.cd_fase_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and (vw.cd_grupo_produto = @cd_grupo_produto or @cd_grupo_produto = 0)
    and (vw.cd_produto = @cd_produto or @cd_produto = 0)
    and (vw.cd_fase_produto = @cd_fase_produto or @cd_fase_produto = 0)
  group by 
    vw.cd_produto


  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  Select 
    vw.cd_produto,
    qt_cpv = Sum(isnull(nfe.qt_item_nota_entrada,0)) + Sum(isnull(pf.qt_atual_prod_fechamento,0)) - sum(vw.qt_item_nota_saida),
    vl_cpv = Sum(isnull(nfe.vl_total_nota_entrada,0) * isnull(nfe.qt_item_nota_entrada,0)) + 
             Sum(isnull(pf.vl_custo_prod_fechamento,0) * isnull(pf.qt_atual_prod_fechamento,0)) - 
             sum(vw.vl_unitario_item_total),
    Sum(isnull(nfe.qt_item_nota_entrada,0)) qt_nota_entrada,
    Sum(isnull(nfe.vl_total_nota_entrada,0) * isnull(nfe.qt_item_nota_entrada,0)) vl_nota_entrada,
    Sum(isnull(pf.qt_atual_prod_fechamento,0)) qt_estoque,
    Sum(isnull(pf.vl_custo_prod_fechamento,0) * isnull(pf.qt_atual_prod_fechamento,0)) vl_estoque,
    sum(vw.qt_item_nota_saida) qt_faturada,
    sum(vw.vl_unitario_item_total) vl_faturada
  into 
    #FaturaDevolucao
  from
    vw_faturamento_devolucao_bi vw
      left outer join
    (select cd_produto, sum(qt_item_nota_entrada) qt_item_nota_entrada, sum(qt_item_nota_entrada * vl_item_nota_entrada) vl_total_nota_entrada
     from nota_entrada_item
     where cd_nota_entrada in(select cd_nota_entrada from nota_entrada 
                              where dt_nota_entrada between @dt_inicial and @dt_final)
           and cd_produto is not null
     group by cd_produto) nfe
      on vw.cd_produto = nfe.cd_produto
      left outer join
    (select cd_produto, cd_fase_produto, qt_atual_prod_fechamento, vl_custo_prod_fechamento
     from produto_fechamento 
     where year(dt_produto_fechamento) =
           case when month(@dt_inicial) = 1 then year(dt_produto_fechamento) - 1
                else year(dt_produto_fechamento) end and
           month(dt_produto_fechamento) = month(@dt_inicial) - 1) pf
      on vw.cd_produto = pf.cd_produto and
         vw.cd_fase_produto = pf.cd_fase_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and (vw.cd_grupo_produto = @cd_grupo_produto or @cd_grupo_produto = 0)
    and (vw.cd_produto = @cd_produto or @cd_produto = 0)
    and (vw.cd_fase_produto = @cd_fase_produto or @cd_fase_produto = 0)
  group by 
    vw.cd_produto

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  Select 
    vw.cd_produto,
    qt_cpv = Sum(isnull(nfe.qt_item_nota_entrada,0)) + Sum(isnull(pf.qt_atual_prod_fechamento,0)) - sum(vw.qt_item_nota_saida),
    vl_cpv = Sum(isnull(nfe.vl_total_nota_entrada,0) * isnull(nfe.qt_item_nota_entrada,0)) + 
             Sum(isnull(pf.vl_custo_prod_fechamento,0) * isnull(pf.qt_atual_prod_fechamento,0)) - 
             sum(vw.vl_unitario_item_total),
    Sum(isnull(nfe.qt_item_nota_entrada,0)) qt_nota_entrada,
    Sum(isnull(nfe.vl_total_nota_entrada,0) * isnull(nfe.qt_item_nota_entrada,0)) vl_nota_entrada,
    Sum(isnull(pf.qt_atual_prod_fechamento,0)) qt_estoque,
    Sum(isnull(pf.vl_custo_prod_fechamento,0) * isnull(pf.qt_atual_prod_fechamento,0)) vl_estoque,
    sum(vw.qt_item_nota_saida) qt_faturada,
    sum(vw.vl_unitario_item_total) vl_faturada
  into 
    #FaturaDevolucaoAnoAnterior
  from
    vw_faturamento_devolucao_mes_anterior_bi vw
      left outer join
    (select cd_produto, sum(qt_item_nota_entrada) qt_item_nota_entrada, sum(qt_item_nota_entrada * vl_item_nota_entrada) vl_total_nota_entrada
     from nota_entrada_item
     where cd_nota_entrada in(select cd_nota_entrada from nota_entrada 
                              where dt_nota_entrada between @dt_inicial and @dt_final)
           and cd_produto is not null
     group by cd_produto) nfe
      on vw.cd_produto = nfe.cd_produto
      left outer join
    (select cd_produto, cd_fase_produto, qt_atual_prod_fechamento, vl_custo_prod_fechamento
     from produto_fechamento 
     where year(dt_produto_fechamento) =
           case when month(@dt_inicial) = 1 then year(dt_produto_fechamento) - 1
                else year(dt_produto_fechamento) end and
           month(dt_produto_fechamento) = month(@dt_inicial) - 1) pf
      on vw.cd_produto = pf.cd_produto and
         vw.cd_fase_produto = pf.cd_fase_produto
  where 
    year(vw.dt_nota_saida) = year(@dt_inicial) and
  	(vw.dt_nota_saida < @dt_inicial) and
  	vw.dt_restricao_item_nota between @dt_inicial and @dt_final
    and (vw.cd_grupo_produto = @cd_grupo_produto or @cd_grupo_produto = 0)
    and (vw.cd_produto = @cd_produto or @cd_produto = 0)
    and (vw.cd_fase_produto = @cd_fase_produto or @cd_fase_produto = 0)
  group by 
    vw.cd_produto

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  Select 
    vw.cd_produto,
    qt_cpv = Sum(isnull(nfe.qt_item_nota_entrada,0)) + Sum(isnull(pf.qt_atual_prod_fechamento,0)) - sum(vw.qt_item_nota_saida),
    vl_cpv = Sum(isnull(nfe.vl_total_nota_entrada,0) * isnull(nfe.qt_item_nota_entrada,0)) + 
             Sum(isnull(pf.vl_custo_prod_fechamento,0) * isnull(pf.qt_atual_prod_fechamento,0)) - 
             sum(vw.vl_unitario_item_atual),
    Sum(isnull(nfe.qt_item_nota_entrada,0)) qt_nota_entrada,
    Sum(isnull(nfe.vl_total_nota_entrada,0) * isnull(nfe.qt_item_nota_entrada,0)) vl_nota_entrada,
    Sum(isnull(pf.qt_atual_prod_fechamento,0)) qt_estoque,
    Sum(isnull(pf.vl_custo_prod_fechamento,0) * isnull(pf.qt_atual_prod_fechamento,0)) vl_estoque,
    sum(vw.qt_item_nota_saida) qt_faturada,
    sum(vw.vl_unitario_item_atual) vl_faturada
  into 
    #FaturaCancelado
  from
    vw_faturamento_cancelado_bi vw
      left outer join
    (select cd_produto, sum(qt_item_nota_entrada) qt_item_nota_entrada, sum(qt_item_nota_entrada * vl_item_nota_entrada) vl_total_nota_entrada
     from nota_entrada_item
     where cd_nota_entrada in(select cd_nota_entrada from nota_entrada 
                              where dt_nota_entrada between @dt_inicial and @dt_final)
           and cd_produto is not null
     group by cd_produto) nfe
      on vw.cd_produto = nfe.cd_produto
      left outer join
    (select cd_produto, cd_fase_produto, qt_atual_prod_fechamento, vl_custo_prod_fechamento
     from produto_fechamento 
     where year(dt_produto_fechamento) =
           case when month(@dt_inicial) = 1 then year(dt_produto_fechamento) - 1
                else year(dt_produto_fechamento) end and
           month(dt_produto_fechamento) = month(@dt_inicial) - 1) pf
      on vw.cd_produto = pf.cd_produto and
         vw.cd_fase_produto = pf.cd_fase_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and (vw.cd_grupo_produto = @cd_grupo_produto or @cd_grupo_produto = 0)
    and (vw.cd_produto = @cd_produto or @cd_produto = 0)
    and (vw.cd_fase_produto = @cd_fase_produto or @cd_fase_produto = 0)
  group by 
    vw.cd_produto


  select 
    a.cd_produto,
    cast(IsNull(a.qt_cpv,0) -
      (isnull(b.qt_cpv,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.qt_cpv,0)
    		end) + 
      isnull(d.qt_cpv,0)) as float) as qt_cpv,
    cast(IsNull(a.vl_cpv,0) -
      (isnull(b.vl_cpv,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.vl_cpv,0)
    		end) + 
      isnull(d.vl_cpv,0)) as float) as vl_cpv,
    cast(IsNull(a.qt_nota_entrada,0) -
      (isnull(b.qt_nota_entrada,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.qt_nota_entrada,0)
    		end) + 
      isnull(d.qt_nota_entrada,0)) as float) as qt_nota_entrada,
    cast(IsNull(a.vl_nota_entrada,0) -
      (isnull(b.vl_nota_entrada,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.vl_nota_entrada,0)
    		end) + 
      isnull(d.vl_nota_entrada,0)) as float) as vl_nota_entrada,
    cast(IsNull(a.qt_estoque,0) -
      (isnull(b.qt_estoque,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.qt_estoque,0)
    		end) + 
      isnull(d.qt_estoque,0)) as float) as qt_estoque,
    cast(IsNull(a.vl_estoque,0) -
      (isnull(b.vl_estoque,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.vl_estoque,0)
    		end) + 
      isnull(d.vl_estoque,0)) as float) as vl_estoque,
    cast(IsNull(a.qt_faturada,0) -
      (isnull(b.qt_faturada,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.qt_faturada,0)
    		end) + 
      isnull(d.qt_faturada,0)) as float) as qt_faturada,
    cast(IsNull(a.vl_faturada,0) -
      (isnull(b.vl_faturada,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.vl_faturada,0)
    		end) + 
      isnull(d.vl_faturada,0)) as float) as vl_faturada
  into 
  	#FaturaResultado
  from 
    #FaturaAnual a
      left outer join  
    #FaturaDevolucao b
  	  on a.cd_produto = b.cd_produto
      left outer join  
    #FaturaDevolucaoAnoAnterior c
  	  on a.cd_produto = c.cd_produto
      left outer join  
    #FaturaCancelado d
  	  on a.cd_produto = d.cd_produto

  Select  
    @vl_total_cpv = isnull(sum(vl_cpv),0),
    @vl_total_faturada = isnull(sum(vl_faturada),0)
  From
  	#FaturaResultado

  -- Mostra a Tabela com dados do Mês
  select  
    a.cd_produto,
    gp.nm_grupo_produto,
    gp.cd_mascara_grupo_produto,
    p.cd_mascara_produto,    
    p.nm_fantasia_produto,
    p.nm_produto,
    un.sg_unidade_medida,
    a.qt_cpv,
    a.vl_cpv,
    (a.vl_cpv / @vl_total_cpv) * 100 as 'pc_cpv',
    a.qt_nota_entrada,
    a.vl_nota_entrada,
    a.qt_estoque,
    a.vl_estoque,
    a.qt_faturada,
    a.vl_faturada,
    (a.vl_faturada / @vl_total_faturada) * 100 as 'pc_faturada'
  from
   	#FaturaResultado a 
  	  left outer join 
    Produto p
      on a.cd_produto = p.cd_produto
      left outer join
    Grupo_produto gp
      on p.cd_grupo_produto = gp.cd_grupo_produto
      left outer join
    Unidade_Medida un
      on p.cd_unidade_medida = un.cd_unidade_medida
  Order by 1 desc

