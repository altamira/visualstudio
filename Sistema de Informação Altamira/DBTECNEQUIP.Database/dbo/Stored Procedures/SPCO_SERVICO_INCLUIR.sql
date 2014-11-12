
/****** Object:  Stored Procedure dbo.SPCO_SERVICO_INCLUIR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_SERVICO_INCLUIR    Script Date: 16/10/01 13:41:41 ******/
/****** Object:  Stored Procedure dbo.SPCO_SERVICO_INCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCO_SERVICO_INCLUIR

	@Codigo    tinyint,
	@Descricao char(40)

AS

BEGIN

	INSERT INTO CO_Servico(cose_Codigo,
 			       cose_Descricao)

		      VALUES (@Codigo,
			      @Descricao)

END

