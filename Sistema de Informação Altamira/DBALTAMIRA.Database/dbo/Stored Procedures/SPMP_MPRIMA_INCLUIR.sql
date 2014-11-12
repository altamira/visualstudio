
/****** Object:  Stored Procedure dbo.SPMP_MPRIMA_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/

CREATE PROCEDURE SPMP_MPRIMA_INCLUIR 

	@Codigo        		char(16),
	 @Valor        		Money ,
	 @Unidade   	    	char(10),
	 @PesoEspec       		float,
	 @Espessura  		float,
	 @Preco    	 	money,
	 @Peso       		float,
	 @Descricao	 	char(60),
	 @Norma  	 	char(10),
	 @Tipo     	 	char(3),
	 @Prioridade 	 	char(2),
	 @DataCadastro 		smalldatetime
AS
BEGIN
    INSERT INTO PR_MPrima 
	 (prmp_Codigo,
	 prmp_Valor,
	 prmp_Unidade,
	 prmp_PesoEspec,
	 prmp_Espessura,
	 prmp_Preco,
	 prmp_Peso,
	 prmp_Descricao,
	 prmp_Norma,
	 prmp_Tipo,
	 prmp_Prioridade,
	 prmp_DataCadastro) 
VALUES 
	( @Codigo,
	 @Valor,
	 @Unidade,
	 @PesoEspec,
	 @Espessura,
	 @Preco,
	 @Peso,
	 @Descricao,
	 @Norma,
	 @Tipo,
	 @Prioridade,
	 @DataCadastro)
END




