
-------------------------------------------------------------------------------
--sp_View_ProcedimentoDispMenu
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 26/05/2005
--Atualizado       : 26/05/2005
--                 : Consulta de Todos os Procedimentos Disponíveis para Cadastro do Menu
--------------------------------------------------------------------------------------------------
create procedure sp_View_ProcedimentoDispMenu
@cd_menu int
AS

--select * from procedimento
--select * from menu_procedimento

  SELECT 
    p.cd_procedimento, 
    p.nm_procedimento, 
    p.nm_sql_procedimento,
    p.nm_procedimento+'-'+p.nm_sql_procedimento as Procedimento

    FROM Procedimento p
   WHERE cd_procedimento not in (SELECT cd_procedimento
                                 FROM Menu_Procedimento
                                WHERE cd_menu = @cd_menu)
  ORDER BY p.nm_procedimento 



