

CREATE PROCEDURE sp_AcessaDica
@ic_parametro_dica int,
@cd_usuario int,
@ic_dica_usuario char(1)
AS
  if @ic_parametro_dica=1 
        UPDATE Usuario SET
               ic_dica_usuario = @ic_dica_usuario
               WHERE cd_usuario = @cd_usuario
  if @ic_parametro_dica=2 
        SELECT ic_dica_usuario FROM Usuario WHERE cd_usuario = @cd_usuario

RETURN

