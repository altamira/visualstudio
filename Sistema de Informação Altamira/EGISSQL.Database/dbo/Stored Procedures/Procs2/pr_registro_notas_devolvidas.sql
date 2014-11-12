
create procedure pr_registro_notas_devolvidas
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_nota_devolvida int

set @qt_nota_devolvida = 0

select  
  @qt_nota_devolvida = count(cd_nota_saida)
from 
  Nota_Saida
where
  dt_nota_saida between @dt_inicial and @dt_final  and
  dt_cancel_nota_saida is not null                 and
  cd_status_nota = 3 or cd_status_nota = 4


--Resultado

select 
  @qt_nota_devolvida as 'RegistroNotaDevolvida'

