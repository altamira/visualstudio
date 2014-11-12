
Create procedure pr_ranking_produto_anual
-----------------------------------------------------------------------------------
--GBS - Global Business Sollution S/A                                          2005
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Autor      : André Seolin Fernandes
--Objetivo   : Mapa de quantidade produto anual
--Data       : 22/09/2005
--14.02.2008 : Acerto para Produtos Fracionados - Carlos Fernandes
-- 14.05.2010 - Grupo/Categoria de Produto - Carlos Fernandes
-----------------------------------------------------------------------------------
@ano             int = 0,
@cd_tipo_mercado int = 0 
as

--select * from parametro_bi

declare @ic_fator_conversao char(1)

select
  @ic_fator_conversao = isnull(ic_conversao_qtd_fator,0)
from
  Parametro_BI with (nolock) 
where
  cd_empresa = dbo.fn_empresa()


Select 
      IDENTITY(int, 1,1)                   as 'Posicao',
      dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      um.sg_unidade_medida,
      max(cp.nm_categoria_produto)         as nm_categoria_produto,
      max(gp.nm_grupo_produto)             as nm_grupo_produto,
      sum(isnull(case when month(pv.dt_pedido_venda) = 1  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Janeiro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 2  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Fevereiro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 3  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Marco',
      sum(isnull(case when month(pv.dt_pedido_venda) = 4  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Abril',
      sum(isnull(case when month(pv.dt_pedido_venda) = 5  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Maio',
      sum(isnull(case when month(pv.dt_pedido_venda) = 6  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Junho',
      sum(isnull(case when month(pv.dt_pedido_venda) = 7  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Julho',
      sum(isnull(case when month(pv.dt_pedido_venda) = 8  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Agosto',
      sum(isnull(case when month(pv.dt_pedido_venda) = 9  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Setembro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 10 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Outubro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 11 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Novembro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 12 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Dezembro',

     (sum(isnull(case when month(pv.dt_pedido_venda) = 1 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 2 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 3 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 4 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 5 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 6 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 7 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 8 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 9 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 10 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 11 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 12 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) ) as 'Total_ano',

      (sum(isnull(case when month(pv.dt_pedido_venda) = 1 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 2  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 3  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 4  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 5  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 6  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 7  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 8  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 9  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 10 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 11 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 12 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0))) / 12 as 'Media',
      max(p.vl_fator_conversao_produt) as fator,
      sum(isnull(case when month(pv.dt_pedido_venda) = 1  then pvi.qt_item_pedido_venda end,0)) as 'qtdJaneiro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 2  then pvi.qt_item_pedido_venda end,0)) as 'qtdFevereiro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 3  then pvi.qt_item_pedido_venda end,0)) as 'qtdMarco',
      sum(isnull(case when month(pv.dt_pedido_venda) = 4  then pvi.qt_item_pedido_venda end,0)) as 'qtdAbril',
      sum(isnull(case when month(pv.dt_pedido_venda) = 5  then pvi.qt_item_pedido_venda end,0)) as 'qtdMaio',
      sum(isnull(case when month(pv.dt_pedido_venda) = 6  then pvi.qt_item_pedido_venda end,0)) as 'qtdJunho',
      sum(isnull(case when month(pv.dt_pedido_venda) = 7  then pvi.qt_item_pedido_venda end,0)) as 'qtdJulho',
      sum(isnull(case when month(pv.dt_pedido_venda) = 8  then pvi.qt_item_pedido_venda end,0)) as 'qtdAgosto',
      sum(isnull(case when month(pv.dt_pedido_venda) = 9  then pvi.qt_item_pedido_venda end,0)) as 'qtdSetembro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 10 then pvi.qt_item_pedido_venda end,0)) as 'qtdOutubro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 11 then pvi.qt_item_pedido_venda end,0)) as 'qtdNovembro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 12 then pvi.qt_item_pedido_venda end,0)) as 'qtdDezembro'
     
into
#temp
from 
      Produto p with (nolock) 
      left outer join Unidade_Medida um     with (nolock) on um.cd_unidade_medida    = p.cd_unidade_medida
      left outer join Pedido_Venda_Item pvi with (nolock) on pvi.cd_produto          = p.cd_produto
      left outer join Pedido_Venda pv       with (nolock) on pv.cd_pedido_venda      = pvi.cd_pedido_venda
      left outer join Cliente   c           with (nolock) on pv.cd_cliente           = c.cd_cliente              
      left outer join Grupo_Produto gp      with (nolock) on gp.cd_grupo_produto     = p.cd_grupo_produto
      left outer join Categoria_Produto cp  with (nolock) on cp.cd_categoria_produto = p.cd_categoria_produto
where 
      pvi.dt_cancelamento_item is null and
      year(pv.dt_pedido_venda) = @ano and
		c.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then c.cd_tipo_mercado else @cd_tipo_mercado end  
Group By 
      p.cd_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      um.sg_unidade_medida
    
select * from #temp order by nm_fantasia_produto

