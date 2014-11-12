
-------------------------------------------------------------------------------
--pr_mapa_ferias
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Mapa de Férias
--Data             : 13/10/2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_mapa_ferias
as
Select
   cc.nm_Centro_custo,
   d.nm_departamento,
   f.nm_funcionario,
   f.cd_chapa_funcionario,
   f.dt_admissao_funcionario
From
   Funcionario f
   left outer join Centro_Custo cc on cc.cd_centro_custo = f.cd_centro_custo
   left outer join Departamento d on d.cd_departamento = f.cd_departamento

