
-------------------------------------------------------------------------------
--sp_helptext pr_atualiza_controle_numeracao_remessa
-------------------------------------------------------------------------------
--pr_atualiza_controle_numeracao_remessa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Atualização da numeração da Remessas
--Data             : 10.10.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_atualiza_controle_numeracao_remessa
@cd_arquivo_magnetico int = 0,
@ic_parametro         int = 0,
@cd_usuario           int = 0

as

if @cd_arquivo_magnetico>0 
begin

  declare @qt_remessa_arquivo int

  select 
    @qt_remessa_arquivo = isnull(qt_remessa_arquivo,0) + 1
  from
    remessa_arquivo_magnetico
  where 
    cd_arquivo_magnetico = @cd_arquivo_magnetico

  if @ic_parametro = 1
  begin
    if not exists( select cd_arquivo_magnetico from remessa_arquivo_magnetico where cd_arquivo_magnetico = @cd_arquivo_magnetico)
    begin
      insert into remessa_arquivo_magnetico
        select
          @cd_arquivo_magnetico,
          @qt_remessa_arquivo,
          @cd_usuario,
          getdate(),
          '',
          getdate()
    end

    update
      remessa_arquivo_magnetico
    set
     qt_remessa_arquivo = @qt_remessa_arquivo,
     dt_remessa_arquivo = getdate()
  
    where 
      cd_arquivo_magnetico = @cd_arquivo_magnetico  

  end

end


