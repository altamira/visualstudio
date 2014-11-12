create procedure pr_processos_bloqueados
as

select
  spid,
  blocked,
  left (hostname,20) as HostName_SPID,
  waitTime_Seg = convert(int,(waittime/1000)),
  open_tran,
  status,
  left(program_name,30) as program_name
from
  master.dbo.sysprocesses
where
  spid in (select blocked from 
           master.dbo.sysprocesses
           where blocked > 0) and
  blocked = 0
order by
  spid


