
create procedure pr_atualiza_log_arquivo_magnetico
@ic_parametro int,
@cd_arquivo_magnetico int output,
@cd_documento_magnetico int,
@nm_local_arq_magnetico varchar(300),
@nm_arquivo_magnetico varchar(20),
@nm_log_reg_arq_magnetico varchar(100),
@qt_linha_detalhe_log int,
@cd_usuario int,
@cd_sequencia_arquivo_magnetico int = 0

as

declare @cd_log_arquivo_magnetico int
declare @cd_novo_arquivo_magnetico int

set @cd_sequencia_arquivo_magnetico = isnull(@cd_sequencia_arquivo_magnetico,0)

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Inclui Log
-------------------------------------------------------------------------------
  begin

    -- encontra próximo código do log
    select
      @cd_log_arquivo_magnetico = (isnull(max(cd_log_arquivo_magnetico),0)+1)
    from
      Log_Arquivo_Magnetico
    where
      cd_documento_magnetico = @cd_documento_magnetico and
      cd_arquivo_magnetico = @cd_arquivo_magnetico

    insert into log_arquivo_magnetico
      (cd_arquivo_magnetico,
       cd_log_arquivo_magnetico,
       cd_documento_magnetico,
       nm_local_arq_magnetico,
       nm_arquivo_magnetico,
       nm_log_reg_arq_magnetico,
       qt_linha_detalhe_log,
       cd_usuario,
       dt_usuario)
    values
      (@cd_arquivo_magnetico,
       @cd_log_arquivo_magnetico,
       @cd_documento_magnetico,
       @nm_local_arq_magnetico,
       @nm_arquivo_magnetico,
       @nm_log_reg_arq_magnetico,
       @qt_linha_detalhe_log,
       @cd_usuario,
       getDate())

  end
-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Registra Arquivo Magnetico
-------------------------------------------------------------------------------
  begin

    select
      @cd_novo_arquivo_magnetico = isnull(max(cd_arquivo_magnetico),0)+1
    from
      Arquivo_Magnetico

    insert into Arquivo_Magnetico
      (cd_arquivo_magnetico,
       cd_documento_magnetico,
       nm_local_arq_magnetico,
       nm_arquivo_magnetico,
       ic_status_arq_magnetico,
       dt_proc_arq_magnetico,
       cd_usuario,
       dt_usuario)
    values
      (@cd_novo_arquivo_magnetico,
       @cd_documento_magnetico,
       @nm_local_arq_magnetico,
       @nm_arquivo_magnetico,
       'S',
       getDate(),
       @cd_usuario,
       getDate())

    set @cd_arquivo_magnetico = @cd_novo_arquivo_magnetico

    if ( @cd_sequencia_arquivo_magnetico > 0 )
    begin
      exec pr_atualiza_sequencia_documento_magnetico @cd_documento_magnetico 
    end

  end
-------------------------------------------------------------------------------
if @ic_parametro = 3    -- Atualiza o Status do Arquivo Magnetico quando ocorrer erros
-------------------------------------------------------------------------------
  begin

    update
      Arquivo_Magnetico
    set
      ic_status_arq_magnetico = 'E',
      cd_usuario = @cd_usuario,
      dt_usuario = getDate()
    where
      cd_arquivo_magnetico = @cd_arquivo_magnetico
      
  end


