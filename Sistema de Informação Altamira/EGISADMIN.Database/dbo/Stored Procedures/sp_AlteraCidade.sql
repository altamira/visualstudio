
CREATE procedure sp_AlteraCidade
--dados depois da execuçao (novos)
@nm_cidade varchar (25),
@sg_cidade char (3),
@cd_ddd_cidade char (3),
@cd_cep_cidade int,
--dados antes da execuçao (antigos)
@cd_pais_old int ,
@cd_estado_old int ,
@cd_cidade_old int
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Cidade SET
         nm_cidade = @nm_cidade,
         sg_cidade = @sg_cidade,
         cd_ddd_cidade = @cd_ddd_cidade,
         cd_cep_cidade = @cd_cep_cidade
     WHERE
         cd_pais = @cd_pais_old and 
         cd_estado = @cd_estado_old and 
         cd_cidade = @cd_cidade_old
   if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end

