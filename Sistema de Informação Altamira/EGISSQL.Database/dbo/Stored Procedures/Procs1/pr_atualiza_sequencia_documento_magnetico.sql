
create PROCEDURE pr_atualiza_sequencia_documento_magnetico
  ( @cd_documento int )

--fn_proxima_sequencia_documento_magnetico
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Eduardo Baião
--Banco de Dados: EgisSql
--Objetivo: Gravar o número que foi usado na geração do arquivo magnético.
--          O sistema usará esta procedure quando o campo do
--          documento for do tipo "Numero Sequencial"
--Data: 01/12/2003
-----------------------------------------------------------------------------------------

AS
BEGIN

  declare @proximo int

  -- Pegar o próximo número da sequência
  set @proximo = dbo.fn_proxima_sequencia_documento_magnetico( @cd_documento )

  if exists ( select top 1 * from sequencia_arquivo_magnetico where cd_documento_magnetico = @cd_documento ) begin

    update sequencia_arquivo_magnetico
      set cd_ultimo_contador = @proximo
    where
      cd_documento_magnetico = @cd_documento

  end
  else
  begin

    insert into sequencia_arquivo_magnetico
      ( cd_documento_magnetico, cd_ultimo_contador )
    values     
      ( @cd_documento, @proximo )

  end

  return(@proximo)

end

