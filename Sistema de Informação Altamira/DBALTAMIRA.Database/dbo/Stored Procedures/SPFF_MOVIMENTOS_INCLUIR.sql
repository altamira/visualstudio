
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOS_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOS_INCLUIR    Script Date: 25/08/1999 20:11:43 ******/
CREATE PROCEDURE SPFF_MOVIMENTOS_INCLUIR

	@Socio		    char(1),
	@Conta   	    char(1),
	@Data       	smalldatetime,
	@Descricao      varchar(30),
    @Operacao  	    char(1), 
	@Valor			money
	
AS

BEGIN

	-- Inclui na tabela de movimentos de CC
	INSERT INTO FI_Movimentos  (fimo_Socio,
							    fimo_Conta,
								fimo_Data,
								fimo_Descricao,
								fimo_Operacao,
								fimo_Valor)
						
						VALUES (@Socio,
								@Conta,
								@Data,
								@Descricao,
								@Operacao,
								@Valor)

                   
END

