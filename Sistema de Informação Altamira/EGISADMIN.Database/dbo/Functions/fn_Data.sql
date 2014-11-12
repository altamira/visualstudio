
---------------------------------------------------------------------------------------
--fn_Data
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2004
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		      : Autor
--Banco de Dados	   : EGISSQL ou EGISADMIN
--Objetivo		      : Pega uma data com Hora e retorna sem a hora...
--		         		  Exemplo	: Passe '01/01/2006 15:13:44' e receba '01/01/2006 00:00:00'
--
--Data			      : 13/04/2004
--Atualização           : 
---------------------------------------------------------------------------------------
CREATE  FUNCTION fn_Data
 (@Data Datetime)  
  
RETURNS DateTime
  
AS  
begin  
  	return convert(nvarchar, @Data - Convert(nvarchar, @Data,114),101)
end  
  
  
  

