CREATE VIEW vw_implantacao_admin_chaves_estrangeiras  
------------------------------------------------------------------------------------  
--vw_documentacao_padrao  
------------------------------------------------------------------------------------  
--GBS - Global Business Solution                                        2004  
------------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)          : Márcio Rodrigues   
--Banco de Dados    : EGISADMIN  
--Objetivo          : Descrição do que a View Realiza  
--Data               : 29/06/2006  
--Atualização        :   
------------------------------------------------------------------------------------  
as  
  SELECT QUOTENAME( c.TABLE_NAME ) as Name, QUOTENAME( c.CONSTRAINT_NAME ) AS Constraints  
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS c  
  WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'   

