

/****** Object:  Stored Procedure dbo.pr_DeletaEstado    Script Date: 13/12/2002 15:08:10 ******/
--pr_DeletaEstado
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Ricardo Barros
--Deleta dados de Estado
--Data         : 06.02.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_DeletaEstado
@cd_pais int output,
@cd_estado int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Estado
     WHERE
         cd_pais = @cd_pais and 
         cd_estado = @cd_estado
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end


