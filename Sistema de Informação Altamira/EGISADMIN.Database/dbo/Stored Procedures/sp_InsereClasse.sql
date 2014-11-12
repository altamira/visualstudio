CREATE procedure sp_InsereClasse  
@cd_classe int output,  
@nm_classe varchar (50) output,  
@cd_usuario int,  
@dt_usuario datetime,  
@ic_alteracao char(1),  
@nm_fluxo_classe varchar(100)
AS  
BEGIN  
  --inicia a transaçao  
  BEGIN TRANSACTION  
  -- gerar codigo e executa travamento  
  SELECT @cd_classe = ISNULL(MAX(cd_classe),0) + 1 FROM Classe TABLOCK  
  INSERT INTO Classe ( cd_classe,  
                       nm_classe,  
                       cd_usuario,  
                       dt_usuario,  
                       ic_alteracao,
                       nm_fluxo_classe )  
      VALUES (@cd_classe,  
              @nm_classe,  
              @cd_usuario,  
              @dt_usuario,  
              @ic_alteracao,
              @nm_fluxo_classe )  
  if @@ERROR = 0  
    COMMIT TRAN  
  else  
  begin  
  --RAISERROR @@ERROR  
    ROLLBACK TRAN  
  end  
end  
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON  
  

