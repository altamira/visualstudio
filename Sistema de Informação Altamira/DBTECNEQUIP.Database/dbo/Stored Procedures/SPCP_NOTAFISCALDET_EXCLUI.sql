
/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALDET_EXCLUI    Script Date: 23/10/2010 15:32:31 ******/
/*** Storage Procedure criada em 20/03/2001 por Marcelo Utikawa da Fonseca
**** Objetivo: Excluir O.P. cancelada.
**** Ações: Exclui os pagamentos existentes. Caso solicitado, também exclui a nota fiscal.
***/

CREATE PROCEDURE  SPCP_NOTAFISCALDET_EXCLUI

@Fornecedor         char(14),
@NotaFiscal          char(6),
@TipoNota            char(1),
@Parcela               smallint,
@ExcluiNota          char(1)

AS

BEGIN

	DELETE FROM CP_NotaFiscalDetalhe
		WHERE  cpnd_Fornecedor = @Fornecedor
		             AND cpnd_NotaFiscal = @NotaFiscal
			AND cpnd_TipoNota = @TipoNota

IF @ExcluiNota = 'S'
   BEGIN
	DELETE FROM CP_NotaFiscal
		WHERE  cpnf_NotaFiscal = @NotaFiscal
   END

END





