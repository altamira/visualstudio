
--pr_migracao_usuario_sap
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Saraiva
--Migraçao dos Usuários para o Banco de Dados SAPSQL e Direitos
--Data             : 06.06.2001
--Atualizado       :
-----------------------------------------------------------------------------------
create procedure pr_migracao_usuario_bdsapsql
as
select 
   nm_fantasia_usuario 
into 
   #AuxSapSql 
from 
   SapAdmin.dbo.Usuario WHERE NM_FANTASIA_USUARIO = 'DENUNI'
declare @fantasia char(15)
while exists ( select * from #AuxSapSql )
begin
  select @Fantasia = nm_fantasia_usuario
  from #AuxSapSql
     -- adiciona o login do usuario ao servidor
     EXEC SP_ADDLOGIN @fantasia,'STANDARDPASSWORD','master','Português'
     -- configura direitos
     EXEC SP_GRANTDBACCESS @fantasia
     EXEC SP_ADDROLEMEMBER 'db_owner', @fantasia
  delete from #AuxSapSql
  where
     @fantasia = nm_fantasia_usuario
end

