
---------------------------------------------------------------------------------------
--fn_documentacao_padrao
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2004
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Autor
--Banco de Dados	: EGISSQL ou EGISADMIN
--Objetivo		: 
--
--Data			: 13/04/2004
--Atualização           : 
---------------------------------------------------------------------------------------

create FUNCTION fn_ultimo_dia_mes (@Data Datetime)  
RETURNS DateTime 
AS    
begin    
declare @Data_Aux as Datetime

  Set @Data_Aux = @Data + (31 - Day(@Data))

  if Month(@Data_Aux) <> Month(@Data) 
    set @Data_Aux = @Data_Aux - Day(@Data_Aux);

return @Data_Aux
 
end   
