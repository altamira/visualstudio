
-------------------------------------------------------------------------------
--pr_resumo_balanco_horario_producao
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
create procedure pr_resumo_balanco_horario_producao

@cd_maquina int = 0,
@dt_inicial datetime,
@dt_final   datetime
as

--select * from processo_categoria_apontamento

   select
     pca.cd_maquina,
     m.nm_fantasia_maquina  as Maquina,
     day (pca.dt_fim)       as Dia,
     cast( 0 as float)      as Qtd,
     cast( 0 as float)      as Perc,
     ca.nm_categoria_apontamento as Categoria  
     
   from
     Processo_Categoria_Apontamento pca
     left outer join Maquina m on m.cd_maquina = pca.cd_maquina
     left outer join Categoria_Apontamento ca  on ca.cd_categoria_apontamento  = pca.cd_categoria_apontamento
   where
     pca.cd_maquina = case when @cd_maquina = 0 then pca.cd_maquina else @cd_maquina end and
     m.nm_fantasia_maquina is not null and
     isnull(ca.ic_pad_categoria,'N')='S'
   group by
     pca.cd_maquina,m.nm_fantasia_maquina,pca.dt_fim,ca.nm_categoria_apontamento
   order by
     m.nm_fantasia_maquina
   


