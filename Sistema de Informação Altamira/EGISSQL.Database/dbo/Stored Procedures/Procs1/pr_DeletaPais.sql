

/****** Object:  Stored Procedure dbo.pr_DeletaPais    Script Date: 13/12/2002 15:08:10 ******/
--pr_DeletaPais
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Ricardo Barros
--Deleta dados de Pais
--Data         : 06.02.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_DeletaPais
@cd_pais int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Pais
     WHERE
         cd_pais = @cd_pais
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end


