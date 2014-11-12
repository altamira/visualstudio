
-------------------------------------------------------------------------------
--sp_helptext sp_View_MenuUsuario  
-------------------------------------------------------------------------------
--sp_View_MenuUsuario  
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Fernandes
--Banco de Dados   : EgisAdmin 
--Objetivo         : Menu por usuários
--Data             : 15.11.2000
--Alteração        : 
--
-- 27.05.2009 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------


--drop procedure sp_View_MenuUsuario  
--go

--Atualizado    : 05.10.2006 -- Tipo da Versão - Carlos Fernandes
--              : 06.10.2006 -- Mostrar somente os Módulo Ativos - Carlos Fernandes

CREATE PROCEDURE sp_View_MenuUsuario  
  
@cd_usuario int = 0,
@cd_empresa int = 0   

 AS   


declare @cd_tipo_versao int

select
  @cd_tipo_versao = isnull(cd_tipo_versao,1)
from
  egisadmin.dbo.empresa e
where
  e.cd_empresa = @cd_empresa 


--select * from modulo
 
   SELECT   
          identity(int,1,1)        as cd_controle,
          0                        as Checado,    
          MU.cd_usuario,    
          MU.cd_modulo,     
          MU.cd_menu,    
          MD.nm_modulo,     
          MN.nm_menu,    
          MU.cd_nivel_acesso,
          v.nm_tipo_versao    
    into
       #MenuUsuario

    FROM 
      Menu_Usuario MU    
      INNER JOIN Menu MN                     on (MU.cd_menu      = MN.cd_menu)    
      INNER JOIN Modulo MD                   on (MU.cd_modulo    = MD.cd_modulo)    
      LEFT OUTER JOIN Modulo_Funcao_Menu MFM on MFM.cd_menu      = MN.cd_menu and
                                                MFM.cd_modulo    = MD.cd_modulo
      LEFT OUTER JOIN Tipo_Versao v          on v.cd_tipo_versao = MN.cd_tipo_versao
    WHERE 
     MU.cd_usuario              = @cd_usuario and
     isnull(MD.ic_liberado,'N') = 'S'    
     and ( isnull(MN.cd_tipo_versao,1) = @cd_tipo_versao or isnull(MN.cd_tipo_versao,1)=1 )
     AND isnull(MFM.cd_funcao,0)>0

 ORDER BY 
   md.nm_modulo, 
   mn.nm_menu    
    

 select 
   *
 from
   #MenuUsuario
 ORDER BY 
   nm_modulo, 
   nm_menu    


