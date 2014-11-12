
-------------------------------------------------------------------------------
--pr_copia_documento_arquivo_magnetico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Executa a Cópia da Estrutura de um Documento/Arquivo Magnético
--                   para um novo, informando a Origem/Destino
--
--Data             : 14.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_copia_documento_arquivo_magnetico
@cd_documento_magnetico_origem  int = 0,
@cd_documento_magnetico_destino int = 0,
@cd_usuario                     int = 0
as

declare @dt_usuario datetime
set @dt_usuario = getdate()

if @cd_documento_magnetico_origem>0 and @cd_documento_magnetico_destino>0 
begin

  --Sessão do Arquivo Magnético
  --select * from sessao_arquivo_magnetico

  select
    *
  into
    #Sessao
  from
    sessao_arquivo_magnetico
  where 
    cd_documento_magnetico = @cd_documento_magnetico_origem

  update
    #Sessao
  set 
    cd_documento_magnetico = @cd_documento_magnetico_destino,
    cd_usuario             = @cd_usuario,
    dt_usuario             = @dt_usuario
  where 
    cd_documento_magnetico = @cd_documento_magnetico_origem
     

  insert into sessao_arquivo_magnetico
    select * from #Sessao


  --Campo do Arquivo Magnetico
  --select * from campo_arquivo_magnetico

  select
    *
  into
    #Campo
  from
    campo_arquivo_magnetico
  where 
    cd_arquivo_magnetico = @cd_documento_magnetico_origem

  update
    #Campo
  set 
    cd_arquivo_magnetico   = @cd_documento_magnetico_destino,
    cd_usuario             = @cd_usuario,
    dt_usuario             = @dt_usuario
  where 
    cd_arquivo_magnetico = @cd_documento_magnetico_origem
     

  insert into campo_arquivo_magnetico
    select * from #Campo



  --Filtros
  --select * from filtro_arquivo_magnetico

  select
    *
  into
    #Filtro
  from
    filtro_arquivo_magnetico
  where 
    cd_documento_magnetico = @cd_documento_magnetico_origem

  update
    #Filtro
  set 
    cd_documento_magnetico = @cd_documento_magnetico_destino,
    cd_usuario             = @cd_usuario,
    dt_usuario             = @dt_usuario
  where 
    cd_documento_magnetico = @cd_documento_magnetico_origem  

  insert into filtro_arquivo_magnetico
    select * from #Filtro

  --Parâmetros de Geração
  --select * from parametro_arquivo_magnetico

  select
    *
  into
    #Parametro
  from
    parametro_arquivo_magnetico
  where 
    cd_documento_magnetico = @cd_documento_magnetico_origem

  update
    #Parametro
  set 
    cd_documento_magnetico = @cd_documento_magnetico_destino,
    cd_usuario             = @cd_usuario,
    dt_usuario             = @dt_usuario
  where 
    cd_documento_magnetico = @cd_documento_magnetico_origem
     
  insert into parametro_arquivo_magnetico
    select * from #Parametro

  --Parâmetros de Atualização
  --select * from atualizacao_arquivo_magnetico

  select
    *
  into
    #Atualizaao
  from
    atualizacao_arquivo_magnetico
  where 
    cd_documento_magnetico = @cd_documento_magnetico_origem

  update
    #Atualizacao
  set 
    cd_documento_magnetico = @cd_documento_magnetico_destino,
    cd_usuario             = @cd_usuario,
    dt_usuario             = @dt_usuario
  where 
    cd_documento_magnetico = @cd_documento_magnetico_origem
     
  insert into atualizacao_arquivo_magnetico
    select * from #Atualizacao

end

