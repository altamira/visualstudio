
-------------------------------------------------------------------------------
--pr_consulta_config_acesso_usuario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_config_acesso_usuario
@cd_usuario int = 0
as

--select * from usuario
--select * from grupousuario
--select * from usuario_GrupoUsuario
--select * from menu
--select * from classe
--select * from modulo_funcao_menu
--select * from funcao

select
  u.nm_fantasia_usuario as Usuario,
  gu.nm_grupo_usuario   as Grupo,
  mo.nm_modulo          as Modulo,
  f.nm_funcao           as Funcao,
  me.nm_menu            as Menu,
  me.nm_menu_titulo     as Titulo,
  c.nm_classe           as Classe

from
  Usuario u
  left outer join Usuario_grupoUsuario ugu on ugu.cd_usuario      = u.cd_usuario
  left outer join GrupoUsuario          gu on gu.cd_grupo_usuario = ugu.cd_grupo_usuario
  left outer join Menu_Usuario mu          on mu.cd_usuario       = u.cd_usuario
  left outer join Menu         me          on me.cd_menu          = mu.cd_menu
  left outer join Modulo       mo          on mo.cd_modulo        = mu.cd_modulo
  left outer join Classe       c           on c.cd_classe         = me.cd_classe
  left outer join Modulo_Funcao_Menu mfm   on mfm.cd_modulo       = mo.cd_modulo and
                                              mfm.cd_menu         = me.cd_menu
  left outer join Funcao f                 on f.cd_funcao         = mfm.cd_funcao

where
  u.cd_usuario = case when @cd_usuario=0 then u.cd_usuario else @cd_usuario end 
  
order by
  u.nm_fantasia_usuario,
  gu.nm_grupo_usuario,
  mo.nm_modulo,
  mfm.cd_indice
