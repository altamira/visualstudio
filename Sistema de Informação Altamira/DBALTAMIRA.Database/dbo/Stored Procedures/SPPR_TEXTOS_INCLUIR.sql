
/****** Object:  Stored Procedure dbo.SPPR_TEXTOS_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/

/****** Object:  Stored Procedure dbo.SPPR_TEXTOS_INCLUIR    Script Date: 23/09/2003 14:01:56 ******/
CREATE PROCEDURE SPPR_TEXTOS_INCLUIR
 	@Numero		int,
	@Item			int,
	@Texto			text,
	@CodAcabamento 	int,
	@Embalagem 		int,
	@CodMontagem	int,
	@LocalMontagem	varchar(40),
	@Usuario		varchar(20)
AS

BEGIN

INSERT INTO PRE_TEXTOS
		(prte_Numero,
		prte_Item,
		prte_Opcao,
		prte_Area,
		prte_Texto,
		prte_Acabamento,
		prte_Embalagem,
		prte_Montagem,
		prte_LocalMontagem,
		prte_Usuario)
	VALUES (@Numero,
		@Item,
		1,
		1,
		@Texto,
		@CodAcabamento,
		@Embalagem,
		@CodMontagem,
		@LocalMontagem,
		@Usuario)
END




