
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): ????????????????????
--Banco de Dados: EGISADMIN
--Objetivo: 
--Data: ??????????
--Atualizado: 
-----------------------------------------------------------------------------------------
CREATE procedure sp_DeletaAtributo  
@cd_tabela int output,  
@cd_atributo int output  
AS  
BEGIN  
  --inicia a transaçao  
  BEGIN TRANSACTION  
  DELETE FROM Atributo  
     WHERE  
         cd_tabela = @cd_tabela and   
         cd_atributo = @cd_atributo  
  if @@ERROR = 0  
    COMMIT TRAN  
  else  
  begin  
  --RAISERROR @@ERROR  
    ROLLBACK TRAN  
  end  
end  
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON   
  

