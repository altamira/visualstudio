
/****** Object:  Stored Procedure dbo.SPMP_MPRIMA_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/

CREATE PROCEDURE SPMP_MPRIMA_ALTERAR
	
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

	UPDATE PR_MPrima

	   SET
	 prmp_Valor		=@Valor,
	 prmp_Unidade		=@Unidade,
	 prmp_PesoEspec	=@PesoEspec,
	 prmp_Espessura		=@Espessura,
	 prmp_Preco		=@Preco,
	 prmp_Peso		=@Peso,
	 prmp_Descricao		=@Descricao,
	 prmp_Norma		=@Norma,
	 prmp_Tipo		=@Tipo,
	 prmp_Prioridade		=@Prioridade,
	 prmp_DataCadastro	=@DataCadastro                         
          
         WHERE prmp_Codigo = @Codigo

END





