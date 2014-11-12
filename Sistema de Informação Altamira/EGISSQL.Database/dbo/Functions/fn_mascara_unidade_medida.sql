
create FUNCTION fn_mascara_unidade_medida
(@cd_unidade_medida int = 0 )
returns varchar(15)

-----------------------------------------------------------------------------------------
--fn_mascara_unidade_medida
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2006
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)       : Carlos Cardoso Fernandes
--Banco de Dados  : EgisSql
--Objetivo        : Retorna a máscara conforme a Unidade de Medida
--Data            : 24.02.2006
--                : 24.02.2006
-----------------------------------------------------------------------------------------

as
begin

  declare @mascara    varchar(15)
  declare @qt_decimal int
  set @qt_decimal = 2

  select
    @qt_decimal  = isnull(qt_decimal_unidade_medida,@qt_decimal)
  from
    Unidade_Medida
  where
    cd_unidade_medida = @cd_unidade_medida

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
