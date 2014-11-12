

/****** Object:  Stored Procedure dbo.pr_AlteraEstado    Script Date: 13/12/2002 15:08:09 ******/
--pr_AlteraEstado
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Ricardo Barros
--Altera dados de Estado
--Data         : 06.02.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_AlteraEstado
--dados depois da execuçao (novos)
@nm_estado varchar (20),
@sg_estado char (2),
--dados antes da execuçao (antigos)
@cd_pais_old int ,
@cd_estado_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Estado SET
         nm_estado = @nm_estado,
         sg_estado = @sg_estado
     WHERE
         cd_pais = @cd_pais_old and 
         cd_estado = @cd_estado_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end


