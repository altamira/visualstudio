
/****** Object:  Stored Procedure dbo.SPFN_POSICAOBANCARIA_EXCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_POSICAOBANCARIA_EXCLUIR    Script Date: 25/08/1999 20:11:43 ******/
CREATE PROCEDURE SPFN_POSICAOBANCARIA_EXCLUIR

	@Banco   char(3),
    @Data    smalldatetime

AS

BEGIN

	DELETE FROM FN_PosBancaria
	      WHERE fnpb_Banco = @Banco
            And fnpb_Data  = @Data

END


