
-------------------------------------------------------------------------------
--sp_helptext pr_analise_consumo_anual_produto
-------------------------------------------------------------------------------
--pr_analise_consumo_anual_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Análise do Consumo de produto
--Data             : 07.03.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_analise_consumo_anual_produto
@dt_inicial datetime = '',
@dt_final   datetime = '',
@cd_produto int      = 0

as

declare @cd_fase_produto int

select
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  parametro_comercial with (nolock)
where
  cd_empresa = dbo.fn_empresa()

--select * from produto_custo

select
  p.cd_produto,
  max(p.cd_mascara_produto)      as cd_mascara_produto,
  max(p.nm_fantasia_produto)     as nm_fantasia_produto,
  max(p.nm_produto)              as nm_produto,
  max(um.sg_unidade_medida)      as sg_unidade_medida,
  max(gp.nm_grupo_produto)       as nm_grupo_produto,
  max(fp.nm_fase_produto)        as nm_fase_produto,
  max(isnull(pc.vl_custo_produto,0))                                                      as CustoReposicao,

  sum(case when isnull(pf.qt_atual_prod_fechamento,0)>0 then
     pf.vl_custo_prod_fechamento / isnull(pf.qt_atual_prod_fechamento,0)
  else
     isnull(pf.vl_custo_prod_fechamento,0)
  end)                                                                                     as CustoUnitario, 
  sum(case when month(pf.dt_produto_fechamento)=1  then qt_saida_prod_fechamento else 0.00 end) as qt_Jan,
  sum(case when month(pf.dt_produto_fechamento)=2  then qt_saida_prod_fechamento else 0.00 end) as qt_Fev,
  sum(case when month(pf.dt_produto_fechamento)=3  then qt_saida_prod_fechamento else 0.00 end) as qt_Mar,
  sum(case when month(pf.dt_produto_fechamento)=4  then qt_saida_prod_fechamento else 0.00 end) as qt_Abr,
  sum(case when month(pf.dt_produto_fechamento)=5  then qt_saida_prod_fechamento else 0.00 end) as qt_Mai,
  sum(case when month(pf.dt_produto_fechamento)=6  then qt_saida_prod_fechamento else 0.00 end) as qt_Jun,
  sum(case when month(pf.dt_produto_fechamento)=7  then qt_saida_prod_fechamento else 0.00 end) as qt_Jul,
  sum(case when month(pf.dt_produto_fechamento)=8  then qt_saida_prod_fechamento else 0.00 end) as qt_Ago,
  sum(case when month(pf.dt_produto_fechamento)=9  then qt_saida_prod_fechamento else 0.00 end) as qt_Set,
  sum(case when month(pf.dt_produto_fechamento)=10 then qt_saida_prod_fechamento else 0.00 end) as qt_Out,
  sum(case when month(pf.dt_produto_fechamento)=11 then qt_saida_prod_fechamento else 0.00 end) as qt_Nov,
  sum(case when month(pf.dt_produto_fechamento)=12 then qt_saida_prod_fechamento else 0.00 end) as qt_Dez

into
  #AnaliseAnual
from
  Produto p with (nolock)
  left outer join Grupo_Produto gp  on gp.cd_grupo_produto  = p.cd_grupo_produto
  left outer join Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida
  inner join produto_custo      pc  on pc.cd_produto        = p.cd_produto
  inner join produto_fechamento pf  on pf.cd_produto        = p.cd_produto and
                                       pf.cd_fase_produto   = case when isnull(p.cd_fase_produto_baixa,0)=0 
                                                              then
                                                                @cd_fase_produto
                                                              else p.cd_fase_produto_baixa end
  left outer join Fase_Produto fp   on fp.cd_fase_produto   = case when isnull(p.cd_fase_produto_baixa,0)=0 
                                                              then
                                                                @cd_fase_produto
                                                              else p.cd_fase_produto_baixa end
where
  p.cd_produto = case when @cd_produto = 0 then p.cd_produto else @cd_produto end
  and pf.dt_produto_fechamento between @dt_inicial and @dt_final

group by
  p.cd_produto

order by
  p.nm_fantasia_produto

declare @qt_total float
declare @vl_total float


select
  *
from
  #AnaliseAnual
order by
  nm_fantasia_produto

--select * from produto_fechamento


