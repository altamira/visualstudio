
/****** Object:  Stored Procedure dbo.SPFF_BANCOS_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_BANCOS_INCLUIR    Script Date: 25/08/1999 20:11:34 ******/
/****** Object:  Stored Procedure dbo.SPFF_BANCOS_INCLUIR    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_BANCOS_INCLUIR

	@Codigo        char(3),
	@Nomebanco     char(15),
	@ValorTaxa     money,
    @ValorBordero  money
AS

BEGIN

	INSERT INTO FF_Bancos (ffba_Codigo,
			               ffba_NomeBanco,
				           ffba_ValorTaxa,
				           ffba_ValorBordero)
		      VALUES (@Codigo,
			          @NomeBanco,
                      @ValorTaxa,
			          @ValorBordero)

END


