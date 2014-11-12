
---------------------------------------------------------------------------------------
--fn_strzero
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2006
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Fernandes / Michel Salvatore
--Banco de Dados	: EGISSQL 
--Objetivo		: Transformar um número inteiro com Zeros a Esquera
--
--Data			: 13.04.2006
--Atualização           : 
---------------------------------------------------------------------------------------

create FUNCTION fn_strzero
(@sString varchar(12),
 @iQtd    int  )

RETURNS varchar(12)

AS
begin
  declare @sZeros varchar(12)

 set
   @sZeros = replicate('0',@iQtd - len(ltrim(rtrim(@sString))))

  return @szeros + @sString

end

-- declare @sString varchar(10)
-- declare @iQtd Integer
-- 
-- declare @sZeros varchar(10)
-- 
-- set @sString = '1'
-- set @iQtd    = 8
-- set @sZeros  = ''
-- 
-- set
--   @sZeros = replicate('0',@iQtd - len(ltrim(rtrim(@sString))))
-- 
-- --select replicate('0',@iQtd)
-- 
-- select @szeros + @sString


