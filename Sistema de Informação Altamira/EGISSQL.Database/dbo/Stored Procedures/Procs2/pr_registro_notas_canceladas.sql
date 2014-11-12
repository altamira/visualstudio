
create procedure pr_registro_notas_canceladas
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_nota_cancelada int

set @qt_nota_cancelada = 0

select  
  @qt_nota_cancelada = count(dt_cancel_nota_saida)
from 
  Nota_Saida
where
  dt_nota_saida between @dt_inicial and @dt_final and       
  dt_cancel_nota_saida is not null


--Resultado

select 
  @qt_nota_cancelada as 'RegistroNotaCancelada'



