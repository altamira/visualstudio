
CREATE    procedure pr_grava_log_supnet
@cd_cliente_sistema integer,  
@cd_usuario_sistema integer    
as  
  
insert into
Log_Usuario_Sistema
(
cd_cliente_sistema,
cd_usuario_sistema,
dt_acesso_usuario,
cd_usuario,
dt_usuario
)
VALUES
(
@cd_cliente_sistema,  
@cd_usuario_sistema,
GETDATE(),
@cd_usuario_sistema,
GETDATE()
)
