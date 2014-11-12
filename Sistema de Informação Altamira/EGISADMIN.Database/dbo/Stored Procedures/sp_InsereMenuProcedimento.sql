
-------------------------------------------------------------------------------
--sp_InsereMenuProcedimento
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
create procedure sp_InsereMenuProcedimento
@cd_procedimento  int,
@cd_menu          int,
@cd_usuario       int,
@dt_usuario       datetime

AS

--select * from menu_procedimento

 Declare @ic_abre_automatico_form char(1)

 Set @ic_abre_automatico_form = 'N'

 INSERT INTO Menu_Procedimento
  (cd_menu, 
   cd_procedimento, 
   ic_abre_procedimento_form,
   cd_usuario, 
   dt_usuario,
   cd_modulo)
 VALUES
   (@cd_menu,
    @cd_procedimento, 
    @ic_abre_automatico_form, 
    @cd_usuario, 
    @dt_usuario,
    0)


