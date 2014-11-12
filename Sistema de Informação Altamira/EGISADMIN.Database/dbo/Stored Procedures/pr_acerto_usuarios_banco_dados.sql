
--pr_acerto_usuarios_banco_dados
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Ricardo 3q / Lucio Saraiva
--Acerto dos Usuários de Bancos de Dados Sap, SapSql
--Data             : 05.06.2001
--Atualizado       :
-----------------------------------------------------------------------------------
CREATE procedure pr_acerto_usuarios_banco_dados
as
select * 
into #AuxUsuario 
from 
   SapAdmin.dbo.Usuario a
--where cd_usuario = 8 
declare @Codigo         char(03)
declare @Fantasia       char(15)
declare @newFant        varchar(15)
declare @Nome           char(40)
declare @Senha          char(05)
declare @Nascimento     datetime
declare @Email          char(30)
declare @Ramal          char(05)
while exists ( select * from #AuxUsuario )
begin
  -- Seleciona o 1o. registro do select da Tabela #AuxProj
  select @Codigo      = cd_usuario,
         @Fantasia    = Substring(nm_fantasia_usuario,1,1) + Lower(Substring(nm_Fantasia_usuario,2,13)),
         @Nome        = Substring(nm_usuario,1,1) + Lower(Substring(nm_Usuario,2,38)),
         @Senha       = cd_Senha_usuario
  from
    #AuxUsuario
    
     -- adiciona o login do usuario ao servidor
     select @newfant = rtrim(@fantasia)
--   EXEC SP_revokeDBACCESS @fantasia
--   EXEC SP_dropROLEMEMBER 'db_owner', @fantasia
--   EXEC SP_DROPLOGIN @fantasia
     EXEC SP_ADDLOGIN @NEWfant,'STANDARDPASSWORD','master','Português'
--   configura direitos
     EXEC SP_GRANTDBACCESS @Newfant
     EXEC SP_ADDROLEMEMBER 'db_owner', @newfant
  delete from #AuxUsuario
  where
     @codigo = cd_usuario
end

