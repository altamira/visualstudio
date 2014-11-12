
create procedure pr_registro_carta_correcoes
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_carta_correcao int

set @qt_carta_correcao = 0

select  
  @qt_carta_correcao = count(cd_carta_correcao)
from 
  carta_correcao
where
  dt_carta_correcao between @dt_inicial and @dt_final  

--select * from carta_correcao

--Resultado

select 
  @qt_carta_correcao as 'RegistroCartaCorrecao'



