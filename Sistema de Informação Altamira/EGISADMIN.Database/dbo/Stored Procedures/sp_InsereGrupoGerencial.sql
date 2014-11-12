
CREATE PROCEDURE [sp_InsereGrupoGerencial]
@cd_grupo_gerencial int output,
@nm_grupo_gerencial varchar(20),
@nu_ordem int
AS
  
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_grupo_gerencial = ISNULL(MAX(cd_grupo_gerencial),0)+1 
    FROM Grupo_Gerencial TABLOCK
  INSERT INTO Grupo_Gerencial 
            ( cd_grupo_gerencial,
              nm_grupo_gerencial,
              nu_ordem)
     VALUES (@cd_grupo_gerencial,
             @nm_grupo_gerencial,
             @nu_ordem)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

