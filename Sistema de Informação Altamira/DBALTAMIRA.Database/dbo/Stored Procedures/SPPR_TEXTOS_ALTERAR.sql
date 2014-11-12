
/****** Object:  Stored Procedure dbo.SPPR_TEXTOS_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/

/****** Object:  Stored Procedure dbo.SPPR_TEXTOS_ALTERAR    Script Date: 23/09/2003 14:01:56 ******/
CREATE PROCEDURE SPPR_TEXTOS_ALTERAR
 
	@Numero		int,
	@Item			int,
	@Texto			text,
	@CodAcabamento 	int,
	@Embalagem 		int,
	@CodMontagem	int,
	@LocalMontagem	varchar(40),
	@Usuario	 	varchar(20)
AS

BEGIN

UPDATE PRE_TEXTOS
		SET 	prte_Texto		= @Texto,
			prte_Acabamento 	= @CodAcabamento,
			prte_Embalagem		= @Embalagem,
			prte_Montagem		=@CodMontagem,
			prte_LocalMontagem	=@LocalMontagem,
			prte_Usuario		= @Usuario
		Where 	prte_Numero 		= @Numero
			and prte_Item 		= @Item
END




