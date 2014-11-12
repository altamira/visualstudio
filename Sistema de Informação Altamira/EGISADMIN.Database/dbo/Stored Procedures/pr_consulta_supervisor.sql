--pr_Consulta_Supervisor
-------------------------------------------------------------------------------------------
-- GBS 
-- Stored Procedure : SQL Server
-- Autor(es)        : Sandro Campos
-- Banco de Dados   : EGISSQL
-- Objetivo         : Consulta do Supervisor
-- Data             : 26.04.2002
-- Atualizado       : 
-- @ic_parametro : 1-> Mensagens enviadas
--	           2-> Mensagens recebidas
--	           3-> Nenhuma mensagem
-- @cd_ocorrencia : C¾digo da ocorrÛncia
-- @cd_usuario    : C¾digo do Usußrio
-- @cd_status     : C¾digo do Status


CREATE           PROCEDURE pr_consulta_supervisor
-- Parametros
@cd_usuario integer

AS
select top 1 *
from egisadmin.dbo.usuario gerencia,
     egisadmin.dbo.usuario_grupousuario grupousuario,
     egisadmin.dbo.Grupousuario grupo
where (
       gerencia.cd_departamento in
       (select usuario.cd_departamento
        from egisadmin.dbo.usuario usuario, 
             egisadmin.dbo.usuario_grupousuario grupousuario,
             egisadmin.dbo.Grupousuario grupo
        where (usuario.cd_usuario = grupousuario.cd_usuario) and
              (grupousuario.cd_grupo_usuario = grupo.cd_grupo_usuario) and
              (grupo.sg_grupo_usuario <> 'GER') and
              (usuario.cd_usuario = @cd_usuario)
        )
      ) and 
      (Gerencia.cd_usuario = grupousuario.cd_usuario) and
      (grupousuario.cd_grupo_usuario = grupo.cd_grupo_usuario) and
      (grupo.sg_grupo_usuario = 'GER') 

