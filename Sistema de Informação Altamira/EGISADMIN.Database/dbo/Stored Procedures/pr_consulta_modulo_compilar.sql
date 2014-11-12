
-------------------------------------------------------------------------------
--pr_consulta_modulo_compilar
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Consulta de Tabelas 
--Data             : 24/12/2004
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_modulo_compilar
@dt_inicial datetime,
@dt_final   datetime

as

--select * from modulo
--select QuoteName(cast(dt_fim_desenvolvimento as varchar(40)), ''''),* from menu_historico where dt_fim_desenvolvimento between '01/20/2005' and '01/20/2005'

select 
 m.sg_modulo                  as Modulo,
 count(mh.cd_modulo)          as QtdOs
from 
  menu_historico mh, Modulo m
where
  m.cd_modulo = mh.cd_modulo and
--cast ( mh.dt_fim_desenvolvimento as varchar(40) ) between QuoteName(cast(@dt_inicial as varchar(40)), '''') and QuoteName(cast(@dt_final as varchar(40)), '''')
  --mh.dt_fim_desenvolvimento between @dt_inicial and @dt_final
  convert(varchar,mh.dt_fim_desenvolvimento,103) between convert(varchar,@dt_inicial,103) and convert(varchar,@dt_final,103)
group by
  m.sg_modulo
order by
  m.sg_modulo

