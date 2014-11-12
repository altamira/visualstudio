
create procedure pr_quantidade_linha_proposta_periodo
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_proposta        int

--select * from vw_proposta_bi where dt_consulta between '01/01/2004' and '01/31/2004'

select  
  @qt_proposta = count(cd_item_consulta)
from 
  vw_proposta_bi
where 
  dt_consulta between @dt_inicial and @dt_final

--Resultado

select
  @qt_proposta as 'QtdLinhaProposta'

