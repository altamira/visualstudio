
-------------------------------------------------------------------------------
--sp_helptext sp_InsereMenuUsuario
-------------------------------------------------------------------------------
--sp_InsereMenuUsuario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cadastro de Menus por Usuário
--Data             : 01/05/2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure sp_InsereMenuUsuario

@cd_menu         int,  
@cd_modulo       int,  
@cd_usuario      int,  
@cd_nivel_acesso int  

AS  


if not exists ( select top 1 cd_menu,cd_modulo,cd_usuario
                from Menu_Usuario
                where
                    cd_menu         = @cd_menu     and
                    cd_modulo       = @cd_modulo   and
                    cd_usuario      = @cd_usuario  and
                    cd_nivel_acesso = @cd_nivel_acesso  )
begin

  INSERT INTO Menu_Usuario  
                   ( cd_menu,  
                     cd_modulo,  
                     cd_usuario,  
                     cd_nivel_acesso,
                     dt_usuario)   
             VALUES 
                    (@cd_menu,   
                     @cd_modulo,   
                     @cd_usuario,  
                     @cd_nivel_acesso,
                     getdate())  
  

end


