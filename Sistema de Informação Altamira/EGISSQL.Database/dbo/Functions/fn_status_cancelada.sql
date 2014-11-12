

CREATE  FUNCTION fn_status_cancelada
  ( @cd_status_nota int )
RETURNS char(1)

AS
BEGIN

  declare @cancelada char(1)

  if ( @cd_status_nota = 7 )
    set @cancelada = 'S'
  else
    set @cancelada = 'N'

  return(@cancelada)

end



