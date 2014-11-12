

/****** Object:  Stored Procedure dbo.pr_InsereEstado    Script Date: 13/12/2002 15:08:10 ******/
--pr_InsereEstado
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Ricardo Barros
--Insere dados em Estado
--Data         : 06.02.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_InsereEstado
@cd_pais int output,
@cd_estado int output,
@nm_estado varchar (20) output,
@sg_estado char (2) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_estado = ISNULL(MAX(cd_estado),0) + 1 FROM Estado TABLOCK
  INSERT INTO Estado( cd_pais,
                      cd_estado,
                      nm_estado,
                      sg_estado)
     VALUES (@cd_pais,
             @cd_estado,
             @nm_estado,
             @sg_estado)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end


