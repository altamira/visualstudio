
-------------------------------------------------------------------------------
--pr_resumo_producao_quantidade_operacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--------------------------------------------------------------------------------------------------
create procedure pr_resumo_producao_quantidade_operacao
@cd_operacao int = 0,
@dt_inicial datetime,
@dt_final   datetime

as

--select * from operacao
--select * from categoria_apontamento
--select * from operacao_apontamento
--select * from processo_categoria_apontamento

--Montagem da Tabela Auxiliar com a Operação e Todas as Categorias Padronizadas

select
  o.cd_operacao,
  o.nm_fantasia_operacao      as Operacao,
  ca.cd_categoria_apontamento,
  ca.nm_categoria_apontamento as Categoria,
  ca.qt_ordem_apontamento     as Ordem
into
  #CategoriaPadrao
from
  Operacao o, Categoria_Apontamento ca
where
  o.cd_operacao = case when @cd_operacao = 0 then o.cd_operacao else @cd_operacao end and
  isnull(ca.ic_pad_categoria,'N')='S'

--select * from #CategoriaPadrao

select
  o.cd_operacao,
  o.nm_fantasia_operacao      as Operacao,
  ca.cd_categoria_apontamento, 
  ca.nm_categoria_apontamento as Categoria,
  ca.qt_ordem_apontamento     as Ordem  
into 
  #CategoriaOperacao
from
  Operacao o
  left outer join Operacao_Apontamento  oa on oa.cd_operacao = o.cd_operacao
  left outer join Categoria_Apontamento ca on ca.cd_categoria_apontamento = oa.cd_categoria_apontamento
  --null(ca.ic_pad_categoria,'N')='S'
where
  o.cd_operacao = case when @cd_operacao = 0 then o.cd_operacao else @cd_operacao end 

insert into #CategoriaOperacao
select * from #CategoriaPadrao

--Montagem da Tabela com as Quantidades Apontadas mensalmente por Operação

select
  pca.cd_operacao,
  pca.cd_categoria_apontamento,
  sum(isnull(case when month(pca.dt_fim) = 1  then isnull(pca.qt_apontamento,0) end,0)) as 'qtJan',
  sum(isnull(case when month(pca.dt_fim) = 2  then isnull(pca.qt_apontamento,0) end,0)) as 'qtFev',
  sum(isnull(case when month(pca.dt_fim) = 3  then isnull(pca.qt_apontamento,0) end,0)) as 'qtMar',
  sum(isnull(case when month(pca.dt_fim) = 4  then isnull(pca.qt_apontamento,0) end,0)) as 'qtAbr',
  sum(isnull(case when month(pca.dt_fim) = 5  then isnull(pca.qt_apontamento,0) end,0)) as 'qtMai',
  sum(isnull(case when month(pca.dt_fim) = 6  then isnull(pca.qt_apontamento,0) end,0)) as 'qtJun',
  sum(isnull(case when month(pca.dt_fim) = 7  then isnull(pca.qt_apontamento,0) end,0)) as 'qtJul',
  sum(isnull(case when month(pca.dt_fim) = 8  then isnull(pca.qt_apontamento,0) end,0)) as 'qtAgo',
  sum(isnull(case when month(pca.dt_fim) = 9  then isnull(pca.qt_apontamento,0) end,0)) as 'qtSet',
  sum(isnull(case when month(pca.dt_fim) = 10 then isnull(pca.qt_apontamento,0) end,0)) as 'qtOut',
  sum(isnull(case when month(pca.dt_fim) = 11 then isnull(pca.qt_apontamento,0) end,0)) as 'qtNov',
  sum(isnull(case when month(pca.dt_fim) = 12 then isnull(pca.qt_apontamento,0) end,0)) as 'qtDez'
into 
  #AuxQtd
from
  processo_categoria_apontamento pca
where
  pca.dt_fim between @dt_inicial and @dt_final
group by
  pca.cd_operacao,
  pca.cd_categoria_apontamento

--Total das Quantidades para Cálculo do (%)

declare @qt_jan   float
declare @qt_fev   float
declare @qt_mar   float
declare @qt_abr   float
declare @qt_mai   float
declare @qt_jun   float
declare @qt_jul   float
declare @qt_ago   float
declare @qt_set   float
declare @qt_out   float
declare @qt_nov   float
declare @qt_dez   float
declare @qt_total float

set @qt_jan   = 0
set @qt_fev   = 0
set @qt_mar   = 0
set @qt_abr   = 0
set @qt_mai   = 0
set @qt_jun   = 0
set @qt_jul   = 0
set @qt_ago   = 0
set @qt_set   = 0
set @qt_out   = 0
set @qt_nov   = 0
set @qt_dez   = 0
set @qt_total = 0

--Apresentação Final do Resumo
select
  @qt_jan   = @qt_jan + isnull(a.qtjan,0),
  @qt_fev   = @qt_fev + isnull(a.qtfev,0),
  @qt_mar   = @qt_mar + isnull(a.qtmar,0),
  @qt_abr   = @qt_abr + isnull(a.qtabr,0),
  @qt_mai   = @qt_mai + isnull(a.qtmai,0),
  @qt_jun   = @qt_jun + isnull(a.qtjun,0),
  @qt_jul   = @qt_jul + isnull(a.qtjul,0),
  @qt_ago   = @qt_ago + isnull(a.qtago,0),
  @qt_set   = @qt_set + isnull(a.qtset,0),
  @qt_out   = @qt_out + isnull(a.qtout,0),
  @qt_nov   = @qt_nov + isnull(a.qtnov,0),
  @qt_dez   = @qt_dez + isnull(a.qtdez,0),
  @qt_total = ( a.qtJan+a.qtFev+a.qtMar+a.qtAbr+a.qtMai+a.qtJun+a.qtJul+a.qtAgo+a.qtSet+a.qtOut+a.qtNov+a.qtDez)
from
  #AuxQtd a

select --co.*, a.*
  co.cd_operacao,
  co.Operacao,
  co.cd_categoria_apontamento,
  co.Categoria,
  co.ordem,
  --Meses
  a.qtJan, case when @qt_jan = 0 then 0 else (isnull(a.qtJan,0)/@qt_jan)*100 end as pc_jan,
  a.qtFev, case when @qt_fev = 0 then 0 else (isnull(a.qtFev,0)/@qt_fev)*100 end as pc_fev,
  a.qtMar, case when @qt_mar = 0 then 0 else (isnull(a.qtMar,0)/@qt_mar)*100 end as pc_mar,
  a.qtAbr, case when @qt_abr = 0 then 0 else (isnull(a.qtAbr,0)/@qt_abr)*100 end as pc_abr,
  a.qtMai, case when @qt_mai = 0 then 0 else (isnull(a.qtMai,0)/@qt_mai)*100 end as pc_mai,
  a.qtJun, case when @qt_jun = 0 then 0 else (isnull(a.qtJun,0)/@qt_jun)*100 end as pc_jun,
  a.qtJul, case when @qt_jul = 0 then 0 else (isnull(a.qtJul,0)/@qt_jul)*100 end as pc_jul,
  a.qtAgo, case when @qt_ago = 0 then 0 else (isnull(a.qtAgo,0)/@qt_ago)*100 end as pc_ago,
  a.qtSet, case when @qt_set = 0 then 0 else (isnull(a.qtSet,0)/@qt_set)*100 end as pc_set,
  a.qtOut, case when @qt_out = 0 then 0 else (isnull(a.qtOut,0)/@qt_out)*100 end as pc_out,
  a.qtNov, case when @qt_nov = 0 then 0 else (isnull(a.qtNov,0)/@qt_nov)*100 end as pc_nov,
  a.qtDez, case when @qt_dez = 0 then 0 else (isnull(a.qtDez,0)/@qt_dez)*100 end as pc_dez,
  --Totais
  a.qtJan+a.qtFev+a.qtMar+a.qtAbr+a.qtMai+a.qtJun+a.qtJul+a.qtAgo+a.qtSet+a.qtOut+a.qtNov+a.qtDez                as Total,
  (a.qtJan+a.qtFev+a.qtMar+a.qtAbr+a.qtMai+a.qtJun+a.qtJul+a.qtAgo+a.qtSet+a.qtOut+a.qtNov+a.qtDez)/12            as Media,
  case when @qt_total = 0 then 0 else
       (a.qtJan+a.qtFev+a.qtMar+a.qtAbr+a.qtMai+a.qtJun+a.qtJul+a.qtAgo+a.qtSet+a.qtOut+a.qtNov+a.qtDez/@qt_total)*100 end as PercTotal

from 
  #CategoriaOperacao co
  left outer join #AuxQtd a on a.cd_operacao              = co.cd_operacao and
                               a.cd_categoria_apontamento = co.cd_categoria_apontamento
order by
  Ordem

