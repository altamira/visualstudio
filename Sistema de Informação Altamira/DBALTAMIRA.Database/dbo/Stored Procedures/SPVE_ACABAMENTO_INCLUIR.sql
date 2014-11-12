
/****** Object:  Stored Procedure dbo.SPVE_ACABAMENTO_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_ACABAMENTO_INCLUIR    Script Date: 25/08/1999 20:11:27 ******/
CREATE PROCEDURE SPVE_ACABAMENTO_INCLUIR

	@Codigo    tinyint,
	@Descricao varchar(46),
    @Custo     float

AS

BEGIN

	INSERT INTO VE_Acabamento (veac_Codigo,
			                   veac_Descricao,
                               veac_Custo)

		      VALUES (@Codigo,
			          @Descricao,
                      @Custo)

END

