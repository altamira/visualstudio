CREATE procedure [dbo].[KILL_ALL_CONNECTIONS]
as

declare @spid as int
declare @tString as nvarchar(15)

select SPId, hostname, program_name, * from master..sysprocesses where DBId = DB_ID('WBCCAD') AND SPId <> @@SPId  /*and program_name = 'ESCOPO' and hostname = 'PROJETO4-PC'*/

while (exists(select SPId from master..sysprocesses where DBId = DB_ID('WBCCAD') AND SPId <> @@SPId /*and program_name = 'ESCOPO'  and hostname = 'PROJETO4-PC'*/))
begin

select @spid = min(SPId) from master..sysprocesses where DBId = DB_ID('WBCCAD') AND SPId <> @@SPId /*and program_name = 'ESCOPO'  and hostname = 'PROJETO4-PC'*/;
select 'Kill Process ID:' + CAST(@spid as nvarchar);

SET @tString = 'KILL ' + CAST(@spid AS VARCHAR(5))
EXEC(@tString)

end

