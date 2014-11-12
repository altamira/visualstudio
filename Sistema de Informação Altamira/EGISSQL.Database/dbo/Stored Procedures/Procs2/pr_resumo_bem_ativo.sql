
-------------------------------------------------------------------------------
--pr_resumo_bem_ativo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumo de Bens do Ativo 
--Data             : 
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_resumo_bem_ativo
@cd_planta          int = 0,
@cd_localizacao_bem int = 0,
@cd_grupo_bem       int = 0,
@cd_centro_custo    int = 0,
@cd_departamento    int = 0,
@cd_area_risco      int = 0,
@cd_seguradora      int = 0

as

select
  max(p.nm_planta)       as Planta,
  count(*)               as Quantidade
from
  Bem b
  left outer join Planta p on p.cd_planta = b.cd_planta
where
  b.cd_planta = case when @cd_planta = 0 then b.cd_planta else @cd_planta end
group by
  b.cd_planta


