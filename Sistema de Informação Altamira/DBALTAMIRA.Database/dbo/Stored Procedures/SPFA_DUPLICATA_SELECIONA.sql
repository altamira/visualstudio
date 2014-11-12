
/****** Object:  Stored Procedure dbo.SPFA_DUPLICATA_SELECIONA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPFA_DUPLICATA_SELECIONA    Script Date: 25/08/1999 20:11:50 ******/
CREATE PROCEDURE SPFA_DUPLICATA_SELECIONA

@NotaFiscal       int

AS
	
BEGIN

     Select   *
         From FA_NotaFiscal

            Where fanf_NotaFiscal = @NotaFiscal
              And fanf_TipoNota = 'S'

END



