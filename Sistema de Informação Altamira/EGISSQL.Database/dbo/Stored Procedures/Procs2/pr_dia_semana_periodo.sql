
-------------------------------------------------------------------------------
--pr_dia_semana_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 23.06.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_dia_semana_periodo
@dt_inicial datetime,
@dt_final   datetime
as

declare @dt_data        datetime
declare @cd_ano_inicial int
declare @cd_ano_final   int
declare @qt_dia         int

set @cd_ano_inicial = year(@dt_inicial)
set @cd_ano_final   = year(@dt_inicial)

set @qt_dia         = ( datediff(day,@dt_inicial,@dt_final) ) + 1

select @qt_dia

select 
  a.dt_agenda,
  a.ic_util,
  a.ic_fabrica_operacao,
  f.nm_feriado  
from 
  Agenda a
  left outer join agenda_feriado af on af.dt_agenda_feriado = a.dt_agenda
  left outer join feriado         f on f.cd_feriado         = af.cd_feriado
where 
--  year(a.dt_agenda) between @cd_ano_inicial and @cd_ano_final
  a.dt_agenda between @dt_inicial and @dt_final


DECLARE Cur_Data CURSOR
FOR
  select 
    a.dt_agenda
  from 
    Agenda a
  where 
     a.dt_agenda between @dt_inicial and @dt_final
OPEN Cur_Data

declare @sql varchar(8000)

set @sql = ''
set @sql = 'Create Table Ze (
    cd_produto int '

FETCH NEXT FROM Cur_Data into @dt_data

WHILE @@FETCH_STATUS = 0
BEGIN
  set @sql = @sql + ', dt_'+dbo.fn_strzero(cast( day(@dt_data)   as varchar(02)),2) 
                           +dbo.fn_strzero(cast( month(@dt_data) as varchar(02)),2) 
                           +dbo.fn_strzero(cast( year(@dt_data)  as varchar(04)),4)
                           +' datetime '
  FETCH NEXT FROM Cur_Data into @dt_data
END
CLOSE Cur_Data
DEALLOCATE Cur_Data

set @sql = @sql +' )'
print @sql

exec (@sql)

select * from ze

--select * from feriado
--select * from agenda_feriado

