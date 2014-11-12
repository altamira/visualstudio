
/****** Object:  Stored Procedure dbo.SPCO_SERVICO_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCO_SERVICO_INCLUIR    Script Date: 25/08/1999 20:11:31 ******/
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

