﻿
create FUNCTION fn_mascara_valor_duas_casas_FF
(@valor float)

RETURNS varchar(8000)

as

begin

declare @num as varchar(800)

set @num = rtrim(ltrim(replace((select convert(varchar, convert(numeric(14,4),round(isnull(@valor,0.00),6,2)),103)),'.','')))

set @num = replicate('0',6 - len(@num)) + @num

return (@num)

end


