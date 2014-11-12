
CREATE PROCEDURE [sp_AtualizaDtAniversariantes] 
@cd_usuario int
AS
  UPDATE Usuario
     SET dt_aniversariantes_usuario = getdate()
   WHERE cd_usuario = @cd_usuario

