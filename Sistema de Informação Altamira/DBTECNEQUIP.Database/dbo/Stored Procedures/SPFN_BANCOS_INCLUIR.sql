
/****** Object:  Stored Procedure dbo.SPFN_BANCOS_INCLUIR    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPFN_BANCOS_INCLUIR    Script Date: 16/10/01 13:41:42 ******/
/****** Object:  Stored Procedure dbo.SPFN_BANCOS_INCLUIR    Script Date: 13/08/1998 09:19:08 ******/
CREATE PROCEDURE SPFN_BANCOS_INCLUIR

	@Codigo        char(3),
	@Nomebanco     char(15),
	@ValorTaxa     money,
    @ValorBordero  money
AS

BEGIN

	INSERT INTO FN_Bancos (fnba_Codigo,
			               fnba_NomeBanco,
				           fnba_ValorTaxa,
				           fnba_ValorBordero)
		      VALUES (@Codigo,
			          @NomeBanco,
                      @ValorTaxa,
			          @ValorBordero)

END

