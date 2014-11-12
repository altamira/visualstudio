
/****** Object:  Stored Procedure dbo.SPCO_ALMOXA_INCLUIR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_ALMOXA_INCLUIR    Script Date: 16/10/01 13:41:42 ******/
/****** Object:  Stored Procedure dbo.SPCO_ALMOXA_INCLUIR    Script Date: 05/01/1999 11:03:42 ******/
CREATE PROCEDURE SPCO_ALMOXA_INCLUIR

	@Codigo    char(9),
	@Descricao char(40),
	@Unidade   char(2),
	@Saldo     float,
	@QtdMinima int,
	@Pasta     tinyint,
    @Servico   tinyint,
	@Valor     money

AS

BEGIN

	INSERT INTO CO_Almoxarifado (coal_Codigo,
			         coal_Descricao,
				     coal_Unidade,
				     coal_Saldo,
				     coal_QtdMinima,
				     coal_Pasta,
                     coal_Servico,
				     coal_Valor)
		      VALUES (@Codigo,
			      @Descricao,
			      @Unidade,
			      @Saldo,
			      @QtdMinima,
			      @Pasta,
                  @Servico,
			      @Valor)

END

