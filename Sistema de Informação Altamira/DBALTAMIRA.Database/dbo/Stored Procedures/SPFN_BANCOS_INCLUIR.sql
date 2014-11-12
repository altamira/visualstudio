
/****** Object:  Stored Procedure dbo.SPFN_BANCOS_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPFN_BANCOS_INCLUIR    Script Date: 25/08/1999 20:11:35 ******/
CREATE PROCEDURE SPFN_BANCOS_INCLUIR

	@Codigo        char(3),
	@Nomebanco     char(25),
	@ValorTaxa     money,
    	@ValorBordero  money,
    	@ValorLimite   money,
	@Financeiro	Char(1)
AS

BEGIN

	INSERT INTO FN_Bancos (fnba_Codigo,
				           fnba_NomeBanco,
				           fnba_ValorTaxa,
				           fnba_ValorBordero,
			                        fnba_ValorLimite,
				           fnba_Financeiro)
		      VALUES (	@Codigo,
			          	@NomeBanco,
                      			@ValorTaxa,
			          	@ValorBordero,
                      			@ValorLimite,
				@Financeiro)

END



