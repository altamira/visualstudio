
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOS_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOS_ALTERAR    Script Date: 25/08/1999 20:11:42 ******/
CREATE PROCEDURE SPFF_MOVIMENTOS_ALTERAR

	@Sequencia	    int,
	@Socio		    char(1),
	@Conta   	    char(1),
	@Data       	smalldatetime,
	@Descricao      varchar(30),
    @Operacao  	    char(1), 
	@Valor			money

AS
	
BEGIN

	UPDATE Fi_Movimentos
	 
	   SET fimo_Socio         = @Socio,
		   fimo_Conta         = @Conta,
		   fimo_Data          = @Data,
		   fimo_Descricao     = @Descricao,
           fimo_Operacao      = @Operacao,
		   fimo_Valor         = @Valor
		   	 
	 WHERE fimo_Sequencia = @Sequencia

END

