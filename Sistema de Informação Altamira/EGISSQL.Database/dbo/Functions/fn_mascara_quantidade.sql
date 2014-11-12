
---------------------------------------------------------------------------------------
--fn_mascara_quantidade  
-----------------------------------------------------------------------------------------  
--fn_mascara_quantidade  
-----------------------------------------------------------------------------------------  
--GBS - Global Business Solution                                                    2006  
--Stored Procedure: Microsoft SQL Server 2000  
--Autor(es)       : Carlos Cardoso Fernandes  
--Banco de Dados  : EgisSql  
--Objetivo        : Retorna a máscara conforme a Quantidade de Casas Decimais Informado  
--Data            : 24.02.2006  
--                : 24.02.2006  
--Atualização     : 08.10.2007
---------------------------------------------------------------------------------------


create FUNCTION fn_mascara_quantidade  
(@qt_decimal int = 0 )  
returns varchar(15)  
  
 
as  
begin  
  
  declare @mascara    varchar(15)  
  
  --Máscara Padrão  
  set @mascara = '#,##0.00'  
  
  if @qt_decimal = 0  
     set @mascara = '#,##0'  
  
  if @qt_decimal = 1  
     set @mascara = '#,##0.0'  
  
  if @qt_decimal = 2  
     set @mascara = '#,##0.00'  
  
  if @qt_decimal = 3  
     set @mascara = '#,##0.000'  
  
  if @qt_decimal = 4  
     set @mascara = '#,##0.0000'  
  
  if @qt_decimal = 5  
     set @mascara = '#,##0.00000'  
    
  return(@mascara)  
  
end  
  
---------------------------------------------------------------------------------------
--Executando
---------------------------------------------------------------------------------------
--select dbo.fn_mascara_quantidade(5) as Marcara

