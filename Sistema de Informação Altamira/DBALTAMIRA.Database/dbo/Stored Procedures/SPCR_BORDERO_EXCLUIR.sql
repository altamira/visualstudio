
/****** Object:  Stored Procedure dbo.SPCR_BORDERO_EXCLUIR    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCR_BORDERO_EXCLUIR    Script Date: 25/08/1999 20:11:24 ******/
CREATE PROCEDURE SPCR_BORDERO_EXCLUIR  

@NotaFiscal       int,
@TipoNota         char(1),
@Parcela          tinyint

AS

BEGIN


    DELETE FROM CR_Bordero
          WHERE crbo_NotaFiscal = @NotaFiscal
            AND crbo_TipoNota = @TipoNota
            AND crbo_Parcela = @Parcela

END




	
                            
		      

