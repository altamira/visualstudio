
CREATE PROCEDURE pr_implantacao_deleta_usuario
As
--Deleta usuario EGISSQL
	select DISTINCT o.name as nm_usuario
   into #usuario
	from dbo.sysusers o 
   left join (select sid, loginname, 1 as matched from master.dbo.syslogins) l on l.sid = o.sid 
   where ((o.issqlrole != 1 and o.isapprole != 1 and o.status != 0 and matched is not null) 
         or (o.sid = 0x00) and o.hasdbaccess = 1) and o.isaliased != 1 and o.name <> 'gbs' and o.name <> 'dbo'
   order by o.name
-- select* from #usuario
-- drop table #usuario
   declare @nm_usuario as varchar(100)
   while exists ( select top 1 nm_usuario from #usuario )
   begin
        select top 1
        @nm_usuario = nm_usuario
        from #Usuario
        print @nm_usuario
        EXECUTE msdb.dbo.sp_check_for_owned_jobsteps @login_name = @nm_usuario
        exec sp_revokedbaccess @nm_usuario
        if not exists(select name from master.dbo.sysdatabases where upper(name) = 'EGISADMIN')
           exec sp_droplogin @nm_usuario
        delete from #usuario where nm_usuario=@nm_usuario
    end 
    drop table #Usuario
PRINT 'ADMIN'
--Deleta usuario ADMIN
   if exists(select name from master.dbo.sysdatabases where upper(name) = 'EGISADMIN')
   begin
	     select DISTINCT o.name as nm_usuario
        into #usuario2
	     from EGISADMIN.dbo.sysusers o 
             left join (select sid, loginname, 1 as matched from master.dbo.syslogins) l on l.sid = o.sid 
        where ((o.issqlrole != 1 and o.isapprole != 1 and o.status != 0 and matched is not null) 
             or (o.sid = 0x00) and o.hasdbaccess = 1) and o.isaliased != 1 and o.name <> 'gbs' and o.name <> 'dbo'
        order by o.name

       while exists ( select top 1 nm_usuario from #usuario2 )
       begin
           select top 1
                  @nm_usuario = nm_usuario
           from #Usuario2

           EXECUTE msdb.dbo.sp_check_for_owned_jobsteps @login_name = @nm_usuario
  	   exec EGISADMIN.dbo.sp_revokedbaccess @nm_usuario         
           exec sp_droplogin @nm_usuario

           delete from #usuario2 where nm_usuario=@nm_usuario
       end   
   end

