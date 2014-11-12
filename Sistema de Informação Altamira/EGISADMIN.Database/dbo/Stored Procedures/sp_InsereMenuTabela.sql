
CREATE PROCEDURE [sp_InsereMenuTabela]
@cd_tabela int,
@cd_menu int,
@cd_usuario int,
@dt_usuario datetime,
@ic_alteracao char(1)
AS
 Declare @ic_abre_automatico_form char(1)
 Set @ic_abre_automatico_form = 'N'
 INSERT INTO Menu_Tabela (cd_menu, cd_tabela, ic_abre_automatico_form, cd_usuario, dt_usuario, ic_alteracao)
      VALUES (@cd_menu, @cd_tabela, @ic_abre_automatico_form, @cd_usuario, @dt_usuario, @ic_alteracao)

