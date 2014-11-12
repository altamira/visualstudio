
--pr_migracao_usuario_sap
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Saraiva
--Migraçao dos Usuários do Sap
--Data             : 05.06.2001
--Atualizado       :
-----------------------------------------------------------------------------------
create procedure pr_migracao_usuario_sap
as
select
   a.cod_usu    as 'codigo',  
   a.nome_usu   as 'nome', 
   a.ident_usu  as 'fantasia',
   a.sen_usu    as 'senha',  
   a.dtn_usu    as 'nascimento',
   a.dpt_usu    as 'departamento',
   a.ram_usu    as 'ramal',
   a.email_usu  as 'email'
into #AuxUsuario 
from 
   sap.dbo.cadusu a
--where cod_usu = '07' or cod_usu = '58' -- Agenor e Alberto
declare @Codigo         char(03)
declare @Fantasia       char(15)
declare @Nome           char(40)
declare @Senha          char(05)
declare @Nascimento     datetime
declare @Email          char(30)
declare @Ramal          char(05)
declare @cd_prox_codigo int
set @cd_prox_codigo = (select max(cd_usuario) from usuario) + 1
while exists ( select * from #AuxUsuario )
begin
  -- Seleciona o 1o. registro do select da Tabela #AuxProj
  select @Codigo      = Codigo,
         @Fantasia    = Substring(Fantasia,1,1) + Lower(Substring(Fantasia,2,13)),
         @Nome        = Substring(Nome,1,1) + Lower(Substring(Nome,2,38)),
         @Senha       = Senha,
         @Nascimento  = Nascimento,
         @Email       = Email,
         @Ramal       = Ramal
  from
    #AuxUsuario
  --Inserçao na Tabela de Usuarios
  if not exists(select * from Usuario where Upper(RTrim(nm_fantasia_usuario)) = Upper(RTrim(@fantasia)))
  begin
     insert into Usuario ( cd_usuario, 
                           nm_usuario, 
                           nm_fantasia_usuario, 
                           cd_senha_usuario,
	  		   ic_tipo_usuario, dt_validade_senha_usuario, 
                           qt_tentativa_acesso_usuario, cd_telefone_usuario, 
                           cd_celular_usuario, nm_arquivo_foto_usuario,
			   dt_nascimento_usuario, ic_controle_aniversario, 
			   nm_email_usuario, dt_cadastro_usuario, nm_local_arquivo_usuario, 
			   dt_aniversariantes_usuario, qt_dias_troca, ic_consulta_executiva, 
			   cd_vendedor, nm_ramal_usuario )
     values (@cd_prox_codigo, 
             @Nome,
             @Fantasia,
             @Senha, 
             Null, GetDate()+60, 
             3, Null,
             Null, Null,
             @Nascimento, 'S',
             @Email, getdate(), null,
             Null, 60, 'N', 
             Null, @Ramal )
 
     -- Atualiza o Histórico de Senhas
     INSERT INTO Historico_Senha_Usuario ( dt_troca_senha, cd_usuario, cd_senha_usuario )
        VALUES ( getdate(), @cd_prox_codigo, @senha )
     -- adiciona o login do usuario ao servidor
     EXEC SP_ADDLOGIN @fantasia,'STANDARDPASSWORD','master','Português'
     -- configura direitos
     EXEC SP_GRANTDBACCESS @fantasia
     EXEC SP_ADDROLEMEMBER 'db_owner', @fantasia
     set @cd_prox_codigo = @cd_prox_codigo + 1
  end
  delete from #AuxUsuario
  where
     @codigo = codigo 
end

