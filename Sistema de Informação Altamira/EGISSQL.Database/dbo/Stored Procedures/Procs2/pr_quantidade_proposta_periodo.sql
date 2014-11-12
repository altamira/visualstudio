
create procedure pr_quantidade_proposta_periodo
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_proposta        int

select  
  @qt_proposta = count(distinct cd_consulta)
from 
  vw_proposta_bi
where 
  dt_consulta between @dt_inicial and @dt_final

--Resultado

select
  @qt_proposta as 'QtdProposta'

