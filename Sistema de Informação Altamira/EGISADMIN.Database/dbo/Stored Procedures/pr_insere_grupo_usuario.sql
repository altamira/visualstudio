
-------------------------------------------------------------------------------
--pr_insere_grupo_usuario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio Rodrigues
--Banco de Dados   : EgisAdmin
--Objetivo         : 
--Data             : 15.01.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_insere_grupo_usuario
@cd_parametro int,
@cd_departamento int = 0,
@cd_usuario int = 0
as
	if @cd_parametro = 1 
   begin
			Select top 1 'x'
			From Usuario_GrupoUsuario ugp 
			Where ugp.cd_usuario = @cd_usuario 
	end 
	else 	if @cd_parametro = 2 
   begin
		Insert Into Usuario_GrupoUsuario
		Select gp.cd_grupo_usuario as cd_grupo_usuario,
		 	@cd_usuario as cd_usuario,
		 	99 as cd_usuario_atualiza,
       	getDate() as dt_atualiza,
       	getDate() as dt_usuario        
		from
   		GrupoUsuario gp
   		left join Usuario_GrupoUsuario ugp on (gp.cd_grupo_usuario = ugp.cd_grupo_usuario and ugp.cd_usuario = @cd_usuario) 
		Where 
   		gp.cd_departamento = @cd_departamento and
   		isnull(ugp.cd_grupo_usuario ,0) = 0   
	end
