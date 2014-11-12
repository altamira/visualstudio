CREATE procedure [dbo].[KILL_ALL_CONNECTIONS]
as

declare @spid as int
declare @tString as nvarchar(15)

select SPId, hostname, program_name, * from master..SysProcesses where DBId = DB_ID('DBALTAMIRA') AND SPId <> @@SPId  and program_name = 'ESCOPO'

while (exists(select SPId from master..SysProcesses where DBId = DB_ID('DBALTAMIRA') AND SPId <> @@SPId and program_name = 'ESCOPO' ))
begin

select @spid = min(SPId) from master..SysProcesses where DBId = DB_ID('DBALTAMIRA') AND SPId <> @@SPId and program_name = 'ESCOPO' ;
select 'Kill Process ID:' + CAST(@spid as nvarchar);

SET @tString = 'KILL ' + CAST(@spid AS VARCHAR(5))
EXEC(@tString)

end

