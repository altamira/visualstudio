
-------------------------------------------------------------------------------
--pr_deleta_usuario
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
create procedure pr_deleta_usuario
@cd_usuario int = 0,
@nm_banco varchar(15) = ''
as
   Declare @msn varchar(150)
   Declare @nm_usuario varchar(100)
  
	SELECT @nm_usuario = nm_fantasia_usuario 
	FROM Usuario u 
	WHERE
		cd_usuario = @cd_usuario

	if isnull(@nm_usuario, '') = ''
   begin
        set @msn = 'Usuário Não Existe!'
        print 'ERROR'
   end
	else
	begin
			Begin Transaction

			Print 'Historico_Senha_Usuario'
			Delete
			from 	Historico_Senha_Usuario
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			Print 'Log_Usuario_Sistema'
			Delete
			from 	Log_Usuario_Sistema
			where cd_usuario_sistema = @cd_usuario
			--*****************************************************************************

			Print 'LogUsuario'
			Delete
			from 	LogUsuario
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			Print 'Menu_Usuario'
			Delete
			from 	Menu_Usuario
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			Print 'Usuario_Acesso_Automatico'
			Delete
			from 	Usuario_Acesso_Automatico
			where cd_usuario_acesso	 = @cd_usuario
			--*****************************************************************************

			Print 'Usuario_Assinatura'
			Delete
			from 	Usuario_Assinatura
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			Print 'Usuario_Classe_TabSheet'
			Delete
			from 	Usuario_Classe_TabSheet
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			Print 'Usuario_Classe_TabSheet'
			Delete
			from 	Usuario_Classe_TabSheet
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			Print 'Usuario_Config'
			Delete
			from 	Usuario_Config
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			Print 'Usuario_GrupoUsuario'
			Delete
			from 	Usuario_GrupoUsuario
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			Print 'Usuario_Info_Gerencial'
			Delete
			from 	Usuario_Info_Gerencial
			where cd_usuario_info_gerencial = @cd_usuario
			--*****************************************************************************

			Print 'Usuario_Internet'
			Delete
			from 	Usuario_Internet
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			Print 'Usuario_Lembrete'
			Delete
			from 	Usuario_Lembrete
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			Print 'Usuario_Log'
			Delete
			from 	Usuario_Log
			where cd_usuario_log = @cd_usuario
			--*****************************************************************************

			Print 'Usuario_Menu_Internet'
			Delete
			from 	Usuario_Menu_Internet
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			Print 'Usuario_Modulo'
			Delete
			from 	Usuario_Modulo
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			Print 'Menu_Historico'
			Delete
			from 	Menu_Historico
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			Print 'Usuario'
			Delete
			from 	Usuario
			where cd_usuario = @cd_usuario
			--*****************************************************************************

			if @@error <> 0
			begin
              rollback transaction
              set @msn = 'Ocorreu um erro interno do Banco de Dados ao Deletar o Usuários!'
              print 'ERROR'
			end
         else
         begin
					commit transaction
					set @msn = 'Usuários Deletado com exito!'
					print 'OK' 
               -- Banco Admin
					EXEC sp_revokedbaccess @nm_usuario
					EXEC sp_dropuser @nm_usuario
               -- Banco SQL
					EXEC(@nm_banco+'.dbo.sp_revokedbaccess ' + @nm_usuario)
					EXEC(@nm_banco+'.dbo.sp_dropuser ' + @nm_usuario)
         end
   end
   --Mostra Mensagem
   RAISERROR (@msn, 16, 1)
