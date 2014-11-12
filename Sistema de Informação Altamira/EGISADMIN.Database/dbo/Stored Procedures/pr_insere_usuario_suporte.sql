
CREATE PROCEDURE pr_insere_usuario_suporte
@cd_cliente_sistema as integer,
@nm_usuario_sistema as varchar(40),
@nm_fantasia_usuario as varchar(15),
@cd_senha_usuario_sistema as varchar(15),
@dt_nascimento_usuario as datetime,
@nm_obs_usuario_sistema as varchar(40),
@cd_usuario as integer
AS
DECLARE @cd_usuario_sistema as integer

SET @cd_usuario_sistema = (select ISNULL(max(cd_usuario_sistema),0) + 1 from Usuario_Cliente_Sistema where cd_cliente_sistema = @cd_cliente_sistema)

INSERT INTO
Usuario_Cliente_Sistema(
cd_cliente_sistema,
cd_usuario_sistema,
nm_usuario_sistema,
nm_fantasia_usuario,
cd_senha_usuario_sistema,
ic_ativo_usuario_sistema,
dt_nascimento_usuario,
nm_obs_usuario_sistema,
cd_usuario,
dt_usuario
)
VALUES (
@cd_cliente_sistema,
@cd_usuario_sistema,
@nm_usuario_sistema,
@nm_fantasia_usuario,
@cd_senha_usuario_sistema,
'S',
@dt_nascimento_usuario,
@nm_obs_usuario_sistema,
@cd_usuario,
GETDATE()
)
