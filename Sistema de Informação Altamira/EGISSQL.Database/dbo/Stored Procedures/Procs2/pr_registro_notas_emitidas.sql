
create procedure pr_registro_notas_emitidas
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_nota_emitida int

set @qt_nota_emitida = 0

select  
  @qt_nota_emitida = count(cd_nota_saida)
from 
  Nota_Saida
where
  dt_nota_saida between @dt_inicial and @dt_final  

--select * from carta_correcao

--Resultado

select 
  @qt_nota_emitida as 'RegistroNotaEmitida'



