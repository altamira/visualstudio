
/****** Object:  Stored Procedure dbo.SPCR_NOTASFISCAISDET_EXCLUIR    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCR_NOTASFISCAISDET_EXCLUIR    Script Date: 25/08/1999 20:11:33 ******/
CREATE PROCEDURE SPCR_NOTASFISCAISDET_EXCLUIR

@NotaFiscal        int,
@TipoNota          char(1)       

AS

BEGIN

    DELETE FROM CR_NotasFiscaisDetalhe
       WHERE crnd_NotaFiscal = @NotaFiscal
         AND crnd_TipoNota   = @TipoNota


    UPDATE FA_NotaFiscal
	   SET fanf_Cancelada = 'S'
          WHERE fanf_NotaFiscal = @NotaFiscal
            AND fanf_TipoNota = @TipoNota

END

