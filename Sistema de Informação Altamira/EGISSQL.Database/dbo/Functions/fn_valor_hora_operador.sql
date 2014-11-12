
CREATE FUNCTION fn_valor_hora_operador
(@cd_operador int,
 @dt_base datetime)
RETURNS numeric(18,4)

AS
BEGIN

  declare @vl_hora_operador numeric(18,4), --Valor da hora do operador
          @cd_mes int, --Mês Base
          @cd_ano int, --Ano Base
          @qt_hora_diaria float, --Qtde. de horas diárias
          @qt_dia_util int --Número de dias úteis para a data base

  --Define o mês e o ano
  Select 
     @cd_mes = DATEPART ( month , @dt_base ),
     @cd_ano = DATEPART ( year , @dt_base )

  --Define o número de dias úteis no mês 
  Select 
    @qt_dia_util = count('x')
  from
    Agenda
  where
    year(dt_agenda) = @cd_ano
    and month(dt_agenda) = @cd_mes
    and IsNull(ic_fabrica_operacao,'N') = 'S'
    
  --Define o número de horas por dia
  Select @qt_hora_diaria = IsNull(
    ( Select qt_hora_diaria_agenda from Parametro_Agenda where cd_empresa = dbo.fn_empresa() ) , 8 )


  Select top 1 
    @vl_hora_operador = (case --Verifica se existe um número de dias e horas definidos 
                           when ( ( @qt_dia_util > 0 ) and ( @qt_hora_diaria > 0 ) ) then
                             IsNull(vl_mensal_operador,0) / ( @qt_dia_util * @qt_hora_diaria )
                           else
                             0
                         end)       
  from
    Operador
  where
    cd_operador = @cd_operador

  return (@vl_hora_operador)
end
