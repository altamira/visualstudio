
CREATE PROCEDURE pr_altera_senha_usuario_supnet
@cd_cliente_sistema int = 0,
@cd_usuario_sistema int = 0,
@cd_senha_usuario_sistema varchar(10) = '',
@cd_senha_usuario_sistema_nova varchar(10) = '',
@ic_opcao char(1) = 'V' --  V = Verificar 
                        --  A = Atualizar
AS

IF @ic_opcao = 'V' 
BEGIN
SELECT 
 cd_usuario_sistema
FROM 
  Usuario_Cliente_Sistema
WHERE
  cd_usuario_sistema = @cd_usuario_sistema AND
  cd_senha_usuario_sistema = @cd_senha_usuario_sistema AND
  cd_cliente_sistema = @cd_cliente_sistema
END

IF @ic_opcao = 'A'
BEGIN
  UPDATE
    Usuario_Cliente_Sistema
  SET
    cd_senha_usuario_sistema = @cd_senha_usuario_sistema_nova,
    cd_usuario = @cd_usuario_sistema,
    dt_usuario = GETDATE()
  WHERE
    cd_usuario_sistema = @cd_usuario_sistema AND
    cd_cliente_sistema = @cd_cliente_sistema
END
