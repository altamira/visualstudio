
-------------------------------------------------------------------------------
--pr_deleta_grupo_usuario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio Rodrigues
--Banco de Dados   : GBSADMIN
--Objetivo         : 
--Data             : 15.01.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_deleta_grupo_usuario
@cd_grupo_usuario int = 0
as
   Declare @msn varchar(150)

 
	if exists(	SELECT 'x' 
					FROM Usuario u 
					INNER JOIN Usuario_GrupoUsuario ug ON u.cd_usuario = ug.cd_usuario
					WHERE
						cd_grupo_usuario = @cd_grupo_usuario)
   begin
        set @msn = 'Existem Usuários neste Grupo, Alterar primeiro os Usuários.!'
        print 'ERROR'
   end
	else
	begin
			Begin Transaction
			--*****************************************************************************
         Print 'Grupo_Usuario_Classe_TabSheet'
         Delete
         from 	Grupo_Usuario_Classe_TabSheet
         where cd_grupo_usuario = @cd_grupo_usuario
			 --*****************************************************************************	
			Print 'Grupo_Usuario_Menu'
			Delete
			from 	Grupo_Usuario_Menu
			where cd_grupo_usuario = @cd_grupo_usuario
			--*****************************************************************************
			Print 'Menu_GrupoUsuario'
			Delete
			from 	Menu_GrupoUsuario
			where cd_grupo_usuario = @cd_grupo_usuario
			--*****************************************************************************
			Print 'Modulo_GrupoUsuario'
			Delete
			from 	Modulo_GrupoUsuario
			where cd_grupo_usuario = @cd_grupo_usuario
			--*****************************************************************************
			Print 'Usuario_GrupoUsuario'
			Delete
			from 	Usuario_GrupoUsuario
			where cd_grupo_usuario = @cd_grupo_usuario
			--*****************************************************************************
			Print 'GrupoUsuario'
			Delete
			from 	GrupoUsuario
			where cd_grupo_usuario = @cd_grupo_usuario
			--*****************************************************************************

			if @@error <> 0
			begin
              rollback transaction
              set @msn = 'Ocorreu um erro interno do Banco de Dados ao Deletar o Grupo de Usuários!'
              print 'ERROR'
			end
         else
         begin
					commit transaction
					set @msn = 'Grupo de Usuários Deletado com exito!'
					print 'OK' 
         end
   end
   --Mostra Mensagem
   RAISERROR (@msn, 16, 1)
