

/****** Object:  Stored Procedure dbo.pr_monta_arquivo_remessa    Script Date: 13/12/2002 15:08:36 ******/

CREATE PROCEDURE pr_monta_arquivo_remessa
@ic_parametro as int
AS

-------------------------------------------------------------------------
-- Parametro 1 para criar o Header do arquivo // Cabeçalho
-------------------------------------------------------------------------
  If @ic_parametro = 1 begin
  
    Select 
      * --All fields
    From 
      Formato_Campo
    Where 
      cd_documento_magnetico = 1 and
      cd_tipo_registro = 1
    Order By 
      cd_formato_campo

  End



