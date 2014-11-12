



CREATE   PROCEDURE sp_DicaAplicacao	
@cd_modulo int
AS
  SELECT ds_dica FROM dica_modulo WHERE 
         ((cd_modulo is null) or (cd_modulo=@cd_modulo)) and
         (ic_ativa_dica='S')
RETURN



