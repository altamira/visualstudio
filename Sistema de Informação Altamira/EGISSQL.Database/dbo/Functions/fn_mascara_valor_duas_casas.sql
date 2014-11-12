
---------------------------------------------------------------------------------------
--fn_soma_dia_parcela
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2004
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Douglas de Paula Lopes
--Banco de Dados	: EGISSQL
--Objetivo		: 
--
--Data			: 06.05.2009
--Atualização           : 
---------------------------------------------------------------------------------------

create FUNCTION fn_mascara_valor_duas_casas
(@valor float)

RETURNS varchar(8000)

as

begin

return (select convert(varchar, convert(numeric(14,2),round(isnull(@valor,0.00),6,2)),103))

end

