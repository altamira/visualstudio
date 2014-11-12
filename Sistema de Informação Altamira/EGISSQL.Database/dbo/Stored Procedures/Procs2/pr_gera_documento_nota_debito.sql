

/****** Object:  Stored Procedure dbo.pr_gera_documento_nota_debito    Script Date: 13/12/2002 15:08:31 ******/

CREATE PROCEDURE pr_gera_documento_nota_debito 
-- Parametros da tabela DOCUMENTO_NOTA_DEBITO
@ic_parametro              int,
@cod_notadebitodoc         int,
@cod_documentoreceber      int,
@vl_documentonotadebito    numeric(15,2),
@qt_dia_atrasonotadebito   int, 
@vl_jurosnotadebito        numeric(15,2),
@dt_usuario                datetime,
@cd_usuario                int

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Geração dos Documentos das Nota de Débito (Documeto_Nota_Debito)
-------------------------------------------------------------------------------
  begin
   insert into Documento_Nota_Debito (cd_nota_debito, cd_documento_receber,
                           vl_documento_nota_debito,
                           qt_dia_atraso_nota_debito, vl_juros_nota_debito,
                           dt_usuario, cd_usuario)

          values          (@cod_notadebitodoc, @cod_documentoreceber,
                           @vl_documentonotadebito,
                           @qt_dia_atrasonotadebito, @vl_jurosnotadebito,
                           @dt_usuario, @cd_usuario)

  end



