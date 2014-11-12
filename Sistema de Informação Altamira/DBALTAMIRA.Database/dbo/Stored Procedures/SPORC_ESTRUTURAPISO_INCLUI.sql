
/****** Object:  Stored Procedure dbo.SPORC_ESTRUTURAPISO_INCLUI    Script Date: 23/10/2010 13:58:22 ******/

CREATE PROCEDURE SPORC_ESTRUTURAPISO_INCLUI
	@codOrcamento int,
	@ep_Conjunto varchar(20) = Null,
	@ep_Peso decimal = Null,
	@ep_Opcao char(10 ) = Null,
	@ep_Total decimal
AS
BEGIN
	INSERT	ORC_EstruturaPiso
				(
				codOrcamento,
				ep_Conjunto,
				ep_Peso,
				ep_Opcao,
				ep_Total
				)
	VALUES
				(
				@codOrcamento,
				@ep_Conjunto,
				@ep_Peso,
				@ep_Opcao,
				@ep_Total
				)

END


