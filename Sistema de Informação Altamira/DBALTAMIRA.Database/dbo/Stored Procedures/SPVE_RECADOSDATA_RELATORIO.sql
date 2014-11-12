
/****** Object:  Stored Procedure dbo.SPVE_RECADOSDATA_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/

/****** Object:  Stored Procedure dbo.SPVE_RECADOSDATA_RELATORIO    Script Date: 25/08/1999 20:11:45 ******/
CREATE PROCEDURE SPVE_RECADOSDATA_RELATORIO

@DataSelecao  smalldatetime

AS

Declare	 @Numero   		char(11),
	 @Data 		smalldatetime 	,
	 @Nome 		char(30)		,
	 @Endereco 		char(30)		,
	 @DDD  	 	char(4)		,
	 @Telefone 		char(25)		,
	 @DDDFax 		char(4)		,
	 @NumeroFax 		char(10)		,
	 @Bairro 		char(25)		,
	 @Cidade 		char(25)		,
	 @Estado 		char(2)		,
	 @Contato 		char(25)		,
	 @Departamento 	char(20)		,
	 @Produto 		int		,
	 @Propaganda 		int		,
	 @Observacao 		char(255)	,
	@Representante 	char(6)		,
	@RazaoSocial    	char(40)		,
	 @EMail		char(25)		,
	@Prazo			smalldatetime	,
	@Numero1  		char(11),
	 @Data1		smalldatetime 	,
	 @Nome1		char(30)		,
	 @Endereco1		char(30)		,
	 @DDD1 	 	char(4)		,
	 @Telefone1		char(25)		,
	 @DDDFax1		char(4)		,
	 @NumeroFax1		char(10)		,
	 @Bairro1		char(25)		,
	 @Cidade1		char(25)		,
	 @Estado1		char(2)		,
	 @Contato1		char(25)		,
	 @Departamento1	char(20)		,
	 @Produto1		int		,
	 @Propaganda1		int		,
	 @Observacao1		char(255)	,
	@Representante1	char(6)		,
	@RazaoSocial1   	char(40)		,
	 @EMail1		char(25)		,
	@Prazo1		smalldatetime      
Begin
   CREATE TABLE #Registros	(Numero   	char(11)		null,
				 Data 		smalldatetime 	null,
				 Nome 		char(30)		null,
				 Endereco 	char(30)		null,
				 DDD 		char(4)		null,
				 Telefone 	char(25)		null,
				 DDDFax 	char(4)		null,
				 NumeroFax 	char(10)		null,
				 Bairro 		char(25)		null,
				 Cidade 		char(25)		null,
				 Estado 	 	char(2)		null,
				 Contato 	char(25)		null,
				 Departamento 	char(20)		null,
				 Produto 	int		null,
				 Propaganda 	int		null,
				 Observacao 	text 		null,
				 Representante 	char(6)		null,
				 RazaoSocial    	char(40)		null,
				 Email		char(25)		null,
				 Prazo		smalldatetime 	null,
				 Numero1  	char(11)		null,
				 Data1		smalldatetime 	null,
				 Nome1		char(30)		null,
				 Endereco1	char(30)		null,
				 DDD1		char(4)		null,
				 Telefone1	char(25)		null,
				 DDDFax1	char(4)		null,
				 NumeroFax1	char(10)		null,
				 Bairro1		char(25)		null,
				 Cidade1		char(25)		null,
				 Estado1		char(2)		null,
				 Contato1	char(25)		null,
				 Departamento1	char(20)		null,
				 Produto1	int		null,
				 Propaganda1	int		null,
				 Observacao1	text 		null,
				 Representante1	char(6)		null,
				 RazaoSocial1   	char(40)		null,
				 Email1		char(25)		null,
				 Prazo1		smalldatetime 	null)

  Declare CurRegistrosGeral Insensitive Cursor
    For SELECT vere_Numero,
           vere_Data,
           vere_Nome,
           vere_Endereco,
           vere_DDD,
           vere_Telefone,
           vere_DDDFax,
           vere_NumeroFax,
           vere_Bairro,
           vere_Cidade,
           vere_Estado,
           vere_Contato,
           vere_Departamento,
           vere_Produto,
           vere_Propaganda,
           vere_Observacao,
           vere_Representante,
           verp_RazaoSocial,
	vere_Email,
	vere_PrazoDoRecado
     FROM VE_Recados, VE_Representantes
     WHERE vere_Representante = verp_Codigo
       AND vere_Data = @DataSelecao ORDER BY vere_Numero

Open CurRegistrosGeral

/*Posiciona primeiro registro*/
Fetch Next From CurRegistrosGeral
    Into @Numero,
           @Data,
           @Nome,
           @Endereco,
           @DDD,
           @Telefone,
           @DDDFax,
           @NumeroFax,
           @Bairro,
           @Cidade,
           @Estado,
           @Contato,
           @Departamento,
           @Produto,
           @Propaganda,
           @Observacao,
           @Representante,
           @RazaoSocial,
            @Email,
	@Prazo

While @@Fetch_Status=0
   Begin
/*Posiciona Segundo registro*/
Fetch Next From CurRegistrosGeral
    Into @Numero1,
           @Data1,
           @Nome1,
           @Endereco1,
           @DDD1,
           @Telefone1,
           @DDDFax1,
           @NumeroFax1,
           @Bairro1,
           @Cidade1,
           @Estado1,
           @Contato1,
           @Departamento1,
           @Produto1,
           @Propaganda1,
           @Observacao1,
           @Representante1,
           @RazaoSocial1,
           @EMail1,
	@Prazo1


      INSERT INTO #Registros
           Values (@Numero,
           @Data,
           @Nome,
           @Endereco,
           @DDD,
           @Telefone,
           @DDDFax,
           @NumeroFax,
           @Bairro,
           @Cidade,
           @Estado,
           @Contato,
           @Departamento,
           @Produto,
           @Propaganda,
           @Observacao,
           @Representante,
           @RazaoSocial,
           @Email,
	@Prazo,
           @Numero1,
           @Data1,
           @Nome1,
           @Endereco1,
           @DDD1,
           @Telefone1,
           @DDDFax1,
           @NumeroFax1,
           @Bairro1,
           @Cidade1,
           @Estado1,
           @Contato1,
           @Departamento1,
           @Produto1,
           @Propaganda1,
           @Observacao1,
           @Representante1,
           @RazaoSocial1,
            @EMail1,
	@Prazo1)
/*Posiciona primeiro registro*/
Fetch Next From CurRegistrosGeral
    Into @Numero,
           @Data,
           @Nome,
           @Endereco,
           @DDD,
           @Telefone,
           @DDDFax,
           @NumeroFax,
           @Bairro,
           @Cidade,
           @Estado,
           @Contato,
           @Departamento,
           @Produto,
           @Propaganda,
           @Observacao,
           @Representante,
           @RazaoSocial,
           @Email,
	@Prazo

end

Close     CurRegistrosGeral
Deallocate  CurRegistrosGeral

Select * from #Registros

end








