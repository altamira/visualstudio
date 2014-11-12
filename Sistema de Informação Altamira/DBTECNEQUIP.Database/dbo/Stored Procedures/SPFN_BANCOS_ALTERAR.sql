
/****** Object:  Stored Procedure dbo.SPFN_BANCOS_ALTERAR    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPFN_BANCOS_ALTERAR    Script Date: 16/10/01 13:41:42 ******/
/****** Object:  Stored Procedure dbo.SPFN_BANCOS_ALTERAR    Script Date: 13/08/1998 09:19:08 ******/
CREATE PROCEDURE SPFN_BANCOS_ALTERAR
	
	@Codigo           char(3),
	@NomeBanco        char(15),
	@ValorTaxa        money,
	@ValorBordero     money

AS


BEGIN


	UPDATE FN_Bancos
	   SET fnba_NomeBanco    = @NomeBanco,
	       fnba_ValorTaxa    = @ValorTaxa,
	       fnba_ValorBordero = @ValorBordero 
         WHERE fnba_Codigo = @Codigo

END

