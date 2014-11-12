
/****** Object:  Stored Procedure dbo.SPPR_SELECAO_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/

/****** Object:  Stored Procedure dbo.SPPR_SELECAO_INCLUIR    Script Date: 07/08/2003 14:01:56 ******/
CREATE PROCEDURE SPPR_SELECAO_INCLUIR
 
	@Produto    	varchar (11),
	@Descricao	varchar(50),
	@Quantidade    	real,
	@Comprimento    	real,
	@Largura    	real,
	@SubNivel 	int,
	@Peso		real,	
	@Preco		real,
	@IPI  		real,
	@Usuario	varchar(20)
AS

BEGIN

DECLARE @Sequencia  tinyint   -- Número do item


   -- Pega o ultimo numero do item
   SELECT @Sequencia = ISNULL(max( prse_Sequencia), 0) + 1        
     FROM PRE_Selecao

INSERT INTO PRE_SELECAO 
	(prse_Sequencia,
	prse_Produto,
	prse_Descricao,
	prse_Quantidade,
	prse_Comprimento,
	prse_Largura,
	prse_SubNivel,
	prse_Peso,
	prse_Preco,
	prse_IPI,
	prse_Usuario) 
VALUES (@Sequencia ,
        	@Produto ,
	@Descricao,
        	@Quantidade ,
	@Comprimento,
	@Largura,
	@SubNivel,
	@Peso,
	@Preco,
	@IPI,
	@Usuario )
END



