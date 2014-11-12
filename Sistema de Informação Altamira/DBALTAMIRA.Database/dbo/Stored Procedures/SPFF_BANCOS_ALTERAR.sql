
/****** Object:  Stored Procedure dbo.SPFF_BANCOS_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_BANCOS_ALTERAR    Script Date: 25/08/1999 20:11:33 ******/
/****** Object:  Stored Procedure dbo.SPFF_BANCOS_ALTERAR    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_BANCOS_ALTERAR
	
	@Codigo           char(3),
	@NomeBanco        char(15),
	@ValorTaxa        money,
	@ValorBordero     money

AS


BEGIN


	UPDATE FF_Bancos
	   SET ffba_NomeBanco    = @NomeBanco,
	       ffba_ValorTaxa    = @ValorTaxa,
	       ffba_ValorBordero = @ValorBordero 
         WHERE ffba_Codigo = @Codigo

END


