
-------------------------------------------------------------------------------
--sp_view_MenusDispUsuario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Consulta dos Módulos para Acesso do Usuário
--Data             : 09/12/2004
--Alteração        : 19.07.2006 - Checagem se o Módulo está Liberado - Carlos Fernandes
--                 : 05.10.2006 - Tipo da Versão - Carlos Fernandes
-- 27.05.2009 - Ajuste / criação tabela temporária - Carlos Fernandes
----------------------------------------------------------------------------------------
create procedure sp_view_MenusDispUsuario
@cd_usuario     int = 0,
@cd_empresa     int = 0   

AS    

declare @cd_tipo_versao int

select
  @cd_tipo_versao = isnull(cd_tipo_versao,1)
from
  egisadmin.dbo.empresa e
where
  e.cd_empresa = @cd_empresa 

--select * from menu

SELECT DISTINCT
   Modulo.nm_modulo,
   Modulo.cd_modulo, 
   Modulo.sg_modulo,
   Menu.cd_menu, 
   Menu.nm_menu, 
   Menu.ic_nucleo_menu,
   Funcao.nm_funcao,    
   0 as Checado,
   v.nm_tipo_versao

into
  #MenuDispUsuario

FROM Usuario      with (nolock) 
 INNER JOIN Usuario_GrupoUsuario     
    ON Usuario.cd_usuario = Usuario_GrupoUsuario.cd_usuario     
 INNER JOIN Modulo_GrupoUsuario     
    ON Usuario_GrupoUsuario.cd_grupo_usuario = Modulo_GrupoUsuario.cd_grupo_usuario    
 INNER JOIN Modulo_Funcao_Menu     
    ON Modulo_GrupoUsuario.cd_modulo = Modulo_Funcao_Menu.cd_modulo    
 INNER JOIN Modulo     
    ON Modulo_GrupoUsuario.cd_modulo = Modulo.cd_modulo     
 INNER JOIN Menu     
    ON Modulo_Funcao_Menu.cd_menu = Menu.cd_menu    
 INNER JOIN Funcao on Funcao.cd_funcao = Modulo_Funcao_Menu.cd_funcao
 LEFT OUTER JOIN Tipo_Versao v on v.cd_tipo_versao = Menu.cd_tipo_versao
 WHERE 
   Usuario.cd_usuario = @cd_usuario    
   AND isnull(Modulo_Funcao_Menu.cd_funcao,0)>0
   AND Menu.cd_menu not in (SELECT cd_menu     
                              FROM Menu_Usuario    
                             WHERE cd_usuario = @cd_usuario)    and
   isnull(modulo.ic_liberado,'N') = 'S'
   and ( isnull(Menu.cd_tipo_versao,1)= @cd_tipo_versao or isnull(Menu.cd_tipo_versao,1)=1 )

--select * from tipo_versao

ORDER BY 
   Modulo.nm_modulo,
   Funcao.nm_funcao,
   Menu.nm_menu    
   
select
  identity(int,1,1)  as cd_controle,
  *
into
  #MenuUsuarioFinal
from
  #MenuDispUsuario
ORDER BY 
  nm_modulo,
  nm_funcao,
  nm_menu    

select
  *
from
  #MenuUsuarioFinal
ORDER BY 
  nm_modulo,
  nm_funcao,
  nm_menu    
    
