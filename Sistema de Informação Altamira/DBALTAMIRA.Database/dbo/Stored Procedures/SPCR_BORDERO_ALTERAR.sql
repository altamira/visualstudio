
/****** Object:  Stored Procedure dbo.SPCR_BORDERO_ALTERAR    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCR_BORDERO_ALTERAR    Script Date: 25/08/1999 20:11:24 ******/
CREATE PROCEDURE SPCR_BORDERO_ALTERAR

@NotaFiscal       int,
@TipoNota         char(1),
@Parcela          tinyint,
@Banco            char(3)

AS

BEGIN


    UPDATE CR_Bordero
     
       SET crbo_Banco = @Banco
     
     WHERE crbo_NotaFiscal = @NotaFiscal
       AND crbo_TipoNota   = @TipoNota
       AND crbo_Parcela    = @Parcela


END

