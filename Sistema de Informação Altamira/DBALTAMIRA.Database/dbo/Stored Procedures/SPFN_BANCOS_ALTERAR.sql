
/****** Object:  Stored Procedure dbo.SPFN_BANCOS_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPFN_BANCOS_ALTERAR    Script Date: 25/08/1999 20:11:35 ******/
CREATE PROCEDURE SPFN_BANCOS_ALTERAR
	
	@Codigo           char(3),
	@NomeBanco        char(25),
	@ValorTaxa        money,
	@ValorBordero     money,
	@ValorLimite      money,
	@Financeiro	Char(1)

AS


BEGIN


	UPDATE FN_Bancos
	   SET 	fnba_NomeBanco    = @NomeBanco,
		fnba_ValorTaxa    = @ValorTaxa,
		fnba_ValorBordero = @ValorBordero,
	       	fnba_ValorLimite  = @ValorLimite ,
		fnba_Financeiro = @Financeiro
         WHERE fnba_Codigo = @Codigo

END



