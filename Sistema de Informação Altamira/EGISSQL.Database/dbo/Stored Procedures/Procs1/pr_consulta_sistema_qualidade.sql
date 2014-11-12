
-------------------------------------------------------------------------------
--pr_consulta_sistema_qualidade
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 21.09.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_sistema_qualidade
@dt_inicial datetime,
@dt_final   datetime
as

--select * from grupo_norma_qualidade
--select * from norma_qualidade
--select * from norma_qualidade_composicao

--Grupo

select
  gn.cd_mascara_grupo_norma       as Codigo,
  cast(null as varchar(20))       as CodigoNorma,
  cast(null as varchar(20))       as CodigoItem,
  gn.nm_grupo_norma               as Grupo,
  gn.nm_ref_grupo_norma           as Referencia,
  cast(null as varchar(60))       as Norma,
  cast(null as varchar(15))       as ReferenciaNorma,
  cast(null as varchar(60))       as Item,
  cast(null as varchar(15))       as ReferenciaItem
into
  #Grupo
from
  Grupo_Norma_Qualidade gn
order by
  gn.cd_mascara_grupo_norma       


--Norma

select
  gn.cd_mascara_grupo_norma       as Codigo,
  nq.cd_mascara_norma             as CodigoNorma,
  cast(null as varchar(20))       as CodigoItem,
  gn.nm_grupo_norma               as Grupo,
  gn.nm_ref_grupo_norma           as Referencia,
  nq.nm_norma_qualidade           as Norma,
  nq.nm_ref_norma_qualidade       as ReferenciaNorma,
  cast(null as varchar(60))       as Item,
  cast(null as varchar(15))       as ReferenciaItem
into
  #Norma
from
  Grupo_Norma_Qualidade gn
  inner join Norma_Qualidade nq             on nq.cd_grupo_norma      = gn.cd_grupo_norma
order by
  gn.cd_mascara_grupo_norma,       
  nq.cd_mascara_norma             

--Composição da Norma

select
  gn.cd_mascara_grupo_norma       as Codigo,
  nq.cd_mascara_norma             as CodigoNorma,
  nqc.cd_item_mascara_norma       as CodigoItem,
  gn.nm_grupo_norma               as Grupo,
  gn.nm_ref_grupo_norma           as Referencia,
  nq.nm_norma_qualidade           as Norma,
  nq.nm_ref_norma_qualidade       as ReferenciaNorma,
  nqc.nm_item_norma_qualidade     as Item,
  nqc.cd_ref_item_norma_qualidade as ReferenciaItem
into
  #Composicao
from
  Grupo_Norma_Qualidade gn
  inner join Norma_Qualidade nq             on nq.cd_grupo_norma      = gn.cd_grupo_norma
  inner join Norma_Qualidade_Composicao nqc on nqc.cd_norma_qualidade = nq.cd_norma_qualidade
order by
  gn.cd_mascara_grupo_norma,       
  nq.cd_mascara_norma,             
  nqc.cd_item_mascara_norma

select * 
into
  #Sistema
from #Grupo
union all
  select * from #Norma
union all
  select * from #Composicao

--select * from #Sistema

select
  isnull(CodigoItem,isnull(CodigoNorma,Codigo))             as Codigo,
  Grupo,
  Norma,
  Item,
  isnull(Item,isnull(Norma,Grupo))                          as Descricao,
  isnull(ReferenciaItem,isnull(ReferenciaNorma,Referencia)) as Referencia
from
  #Sistema
order by
  Codigo,CodigoNorma,CodigoItem

-- select
--   cd_item_mascara_norma       as Codigo,
--   cast(null as varchar(60))   as Grupo,
--   cd_ref_item_norma_qualidade as Referencia,
-- 
  

