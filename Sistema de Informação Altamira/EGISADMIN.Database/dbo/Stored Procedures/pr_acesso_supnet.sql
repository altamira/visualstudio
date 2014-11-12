
CREATE    procedure pr_acesso_supnet  
@nm_supnet_usuario       char(15),  
@cd_senha_supnet_usuario varchar(10)    
as  
  
select ucs.cd_cliente_sistema,  
       cs.nm_cliente_sistema,
       ucs.cd_usuario_sistema,
       ucs.nm_fantasia_usuario,  
       ucs.nm_usuario_sistema
       
from  
       Usuario_Cliente_Sistema ucs
       LEFT OUTER JOIN
       Cliente_Sistema cs ON ucs.cd_cliente_sistema = cs.cd_cliente_sistema
where  
       ucs.nm_fantasia_usuario      = @nm_supnet_usuario  and  
       ucs.cd_senha_usuario_sistema = @cd_senha_supnet_usuario and  
       ucs.ic_ativo_usuario_sistema = 'S' 
