
CREATE FUNCTION fn_area_placa
(@cd_consulta       int,
 @cd_item_consulta  int,
 @cd_item_orcamento int)

RETURNS float

as

begin

declare @qt_area_placa     float

set @qt_area_placa = 0

select @qt_area_placa = qt_largac_item_orcamento*qt_compac_item_orcamento
from 
  consulta_item_orcamento
where
  cd_consulta       = @cd_consulta      and
  cd_item_consulta  = @cd_item_consulta and
  cd_item_orcamento = @cd_item_orcamento 

return(@qt_area_placa)

END

