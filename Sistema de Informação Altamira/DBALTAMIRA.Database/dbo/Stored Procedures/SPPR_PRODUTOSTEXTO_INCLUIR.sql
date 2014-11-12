
/****** Object:  Stored Procedure dbo.SPPR_PRODUTOSTEXTO_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/

/****** Object:  Stored Procedure dbo.SPPR_PRODUTOSTEXTO_INCLUIR    Script Date: 23/09/2003 14:01:56 ******/
CREATE PROCEDURE SPPR_PRODUTOSTEXTO_INCLUIR
 
	@Numero	int,
	@Item		int,
	@Opcao		int,
	@Sequencia	tinyint,
	@Produto    	varchar (11),
	@Quantidade    	real,
	@Comprimento    	real,
	@Largura    	real,
	@SubNivel 	int,
	@Peso		real,
	@IPI		real,
	@ValorUnitario      money

AS

BEGIN

INSERT INTO PRE_PRODUTOSTEXTO
	(prpt_Numero,
	prpt_Item,
	prpt_Opcao,
	prpt_Sequencia,
	prpt_Produto,
	prpt_Quantidade,
	prpt_Comprimento,
	prpt_Largura,
	prpt_SubNivel,
	prpt_ValorUnitario,
	prpt_IPI,
	prpt_Peso) 
VALUES (@Numero,
	@Item,
	@Opcao,
	@Sequencia ,
        	@Produto ,
        	@Quantidade ,
	@Comprimento,
	@Largura,
	@SubNivel,
	@ValorUnitario,
	@IPI,
	@Peso )
END


