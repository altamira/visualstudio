
-------------------------------------------------------------------------------
--sp_ViewModulo_GrupoUsuario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin 
--Objetivo         : Mostra todos os Módulos do Egis para Seleção
--Data             : 09/12/2004
--Alteração        : 19.07.2006 - Mostrar somente os Liberados - Carlos Fernandes
---------------------------------------------------------------------------------
create procedure sp_ViewModulo_GrupoUsuario
@cd_grupo_usuario int = 0
AS  

  SELECT MD.cd_modulo,  
         MD.nm_modulo,  
         MGU.cd_grupo_usuario    
  FROM Modulo_GrupoUsuario MGU, Modulo MD  
  WHERE 
    MD.cd_modulo *= MGU.cd_modulo  
    and MGU.cd_grupo_usuario = @cd_grupo_usuario  
    and isnull(MD.ic_liberado,'N') = 'S'
  ORDER BY 
    nm_modulo  
  

--select * from modulo

