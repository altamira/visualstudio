
-------------------------------------------------------------------------------
--pr_user_logged
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio Rodrigues Adão
--Banco de Dados   : EgisAdmin
--Objetivo         : 
--Data             : 06/03/2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_user_logged
	@loginame nchar(128),
	@hostname nchar(128)
as
	
Create Table #UserTemp(
	spid smallint, 
	ecid smallint, 
	status nchar(30),
	loginame nchar(128),
	hostname nchar(128), 
	blk char(5), 
	dbname nchar(128), 
	cmd nchar(16) 
)

Delete from #UserTemp
Insert Into #UserTemp
exec sp_who @loginame

Delete from #UserTemp
Where Rtrim(isnull(hostname, '')) = '' 

if exists(Select * from #UserTemp where hostname <> @hostname and Rtrim(isnull(hostname, '')) <> '' )
begin
	(Select top 1 @hostname = hostname from #UserTemp where hostname <> @hostname and Rtrim(isnull(hostname, '')) <> '')
   declare @msn varchar(1000)
   set @msn = 'Usuário ' + Rtrim(Cast(@loginame as Varchar(128))) +' está conectado na máquina ' + Rtrim(Cast(@hostname as Varchar(128))) + ', Login Inválido!'
	RAISERROR (@msn, 16, 1)
end
