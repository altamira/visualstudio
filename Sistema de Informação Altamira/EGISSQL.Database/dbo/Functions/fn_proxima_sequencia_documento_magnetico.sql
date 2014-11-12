
create FUNCTION fn_proxima_sequencia_documento_magnetico
  ( @cd_documento int )
RETURNS int

--fn_proxima_sequencia_documento_magnetico
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Eduardo Baião
--Banco de Dados: EgisSql
--Objetivo: Retorna sempre o próximo número a ser usado nos Arquivos Magnéticos.
--          O sistema usará está função quando o campo do
--          documento for do tipo "Numero Sequencial"
--Data: 01/12/2003
-----------------------------------------------------------------------------------------

AS
BEGIN

  declare @proximo int

  -- Pegar o próximo número da sequência
  select
    @proximo = cd_ultimo_contador
  from
    sequencia_arquivo_magnetico
  where
    cd_documento_magnetico = @cd_documento    

  set @proximo = isnull(@proximo,0) + 1

  return(@proximo)

end

