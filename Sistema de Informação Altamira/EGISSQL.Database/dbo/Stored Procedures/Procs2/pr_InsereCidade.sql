

/****** Object:  Stored Procedure dbo.pr_InsereCidade    Script Date: 13/12/2002 15:08:10 ******/
--pr_InsereCidade
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Ricardo Barros
--Insere dados em Cidade
--Data         : 06.02.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_InsereCidade
@cd_pais int output,
@cd_estado int output,
@cd_cidade int output,
@nm_cidade varchar (25) output,
@sg_cidade char (3) output,
@cd_ddd_cidade char (3) output,
@cd_cep_cidade int output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_cidade = ISNULL(MAX(cd_cidade),0) + 1 FROM Cidade TABLOCK
  INSERT INTO Cidade( cd_pais,
                      cd_estado,
                      cd_cidade,
                      nm_cidade,
                      sg_cidade,
                      cd_ddd_cidade,
                      cd_cep_cidade)
     VALUES (@cd_pais,
             @cd_estado,
             @cd_cidade,
             @nm_cidade,
             @sg_cidade,
             @cd_ddd_cidade,
             @cd_cep_cidade)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
 


