CREATE procedure sp_AlteraClasse  
--dados depois da execuçao (novos)  
@nm_classe varchar (50),  
--dados antes da execuçao (antigos)  
@cd_classe_old int,  
@cd_usuario int,  
@dt_usuario datetime,  
@ic_alteracao char(1),
@nm_fluxo_classe varchar(100)  
AS  
BEGIN  
  --inicia a transaçao  
  BEGIN TRANSACTION  
  --gera código e executa travamento  
  UPDATE Classe SET            
         nm_classe  = @nm_classe,  
         cd_usuario = @cd_usuario,  
         dt_usuario = @dt_usuario,  
         ic_alteracao = @ic_alteracao,
         nm_fluxo_classe = @nm_fluxo_classe
  
     WHERE  
         cd_classe = @cd_classe_old  
  if @@ERROR = 0  
    COMMIT TRAN  
  else  
  begin  
  --RAISERROR @@ERROR  
    ROLLBACK TRAN  
  end  
end  
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON  
  

