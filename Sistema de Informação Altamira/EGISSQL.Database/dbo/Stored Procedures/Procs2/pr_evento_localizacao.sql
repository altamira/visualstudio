
CREATE PROCEDURE pr_evento_localizacao
@ic_parametro int,
@cd_contrato int,
@cd_evento int

As

declare @cd_grupo_local_cemiterio int,
	@cd_count int

-------------------------------------------------------------------------------------------
if @ic_parametro = 1 --Rotina que Insere os Dados na Local_Evento caso ainda não exista
-------------------------------------------------------------------------------------------
begin
  delete from Local_Evento 
  where
    cd_contrato=@cd_contrato and
    cd_evento=@cd_evento

  Select 
	cd_grupo_local_cemiterio, 
	nm_grupo_local_cemiterio,	
	cast(null as varchar(15)) as nm_local_evento,
        @cd_contrato as cd_contrato,
	@cd_evento as cd_evento,
	0 as cd_usuario,
	getdate() as dt_usuario
  Into
	#Evento_Grupo_Localizacao
  from 
	Grupo_Local_Cemiterio

  set @cd_count = 1

  DECLARE Cursor_Produto_Grupo_Localizacao CURSOR FOR
    select cd_grupo_local_cemiterio from #Evento_Grupo_Localizacao

  OPEN Cursor_Produto_Grupo_Localizacao 
  FETCH NEXT FROM Cursor_Produto_Grupo_Localizacao into @cd_grupo_local_cemiterio
  WHILE @@FETCH_STATUS = 0
  BEGIN
     update #Evento_Grupo_Localizacao
     set
--       #Evento_Grupo_Localizacao.nm_local_evento = le.nm_local_evento,
       #Evento_Grupo_Localizacao.cd_usuario = le.cd_usuario,
       #Evento_Grupo_Localizacao.dt_usuario = le.dt_usuario
     From
       #Evento_Grupo_Localizacao, local_evento le
     where
       le.cd_grupo_local_cemiterio = @cd_grupo_local_cemiterio and
       #Evento_Grupo_Localizacao.cd_grupo_local_cemiterio = @cd_grupo_local_cemiterio and
       #Evento_Grupo_Localizacao.cd_evento = le.cd_evento

      set @cd_count = @cd_count + 1
    FETCH NEXT FROM Cursor_Produto_Grupo_Localizacao into @cd_grupo_local_cemiterio
  END
  CLOSE Cursor_Produto_Grupo_Localizacao
  DEALLOCATE Cursor_Produto_Grupo_Localizacao

  select * from #Evento_Grupo_Localizacao

  drop table #Evento_Grupo_Localizacao
end

-------------------------------------------------------------------------------------------
if @ic_parametro = 2 --Consulta os Dados na Local_Evento
-------------------------------------------------------------------------------------------
begin
  select 
    le.cd_contrato,
    le.cd_evento,
    le.cd_grupo_local_cemiterio,
    glc.nm_grupo_local_cemiterio,	
    le.nm_local_evento
  from 
    Local_Evento le
  left outer join Grupo_Local_Cemiterio glc on
    glc.cd_grupo_local_cemiterio=le.cd_grupo_local_cemiterio
  where
    le.cd_contrato=@cd_contrato and
    le.cd_evento=@cd_evento
end

