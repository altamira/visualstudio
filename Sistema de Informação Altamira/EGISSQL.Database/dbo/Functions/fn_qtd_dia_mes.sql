
CREATE FUNCTION fn_qtd_dia_mes
(@dt_agenda      datetime = '')


RETURNS int

AS
BEGIN

  declare @qt_dia int

  set @qt_dia = 31

    
  set @qt_dia = 
  (
  case when month(@dt_agenda)=4 or month(@dt_agenda)=6 or month(@dt_agenda)=9 or month(@dt_agenda)=11 then
     30
  else
    case when month(@dt_agenda)=2 and (year(@dt_agenda)/4 = 0 ) then
      29
    else
      case when month(@dt_agenda)=2 then
         28
      else
         @qt_dia
      end
    end
  end )
  
  --		

  return(@qt_dia)
           
END

