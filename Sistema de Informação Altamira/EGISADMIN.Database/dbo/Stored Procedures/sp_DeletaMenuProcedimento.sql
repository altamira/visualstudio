
-------------------------------------------------------------------------------
--sp_DeletaMenuProcedimento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 26/05/2005
--Atualizado       : 26/05/2005
--                 : 
--------------------------------------------------------------------------------------------------
create procedure sp_DeletaMenuProcedimento
@cd_procedimento int,
@cd_menu         int
AS

 DELETE FROM Menu_Procedimento
      WHERE cd_menu          = @cd_menu AND
            cd_procedimento  = @cd_procedimento



