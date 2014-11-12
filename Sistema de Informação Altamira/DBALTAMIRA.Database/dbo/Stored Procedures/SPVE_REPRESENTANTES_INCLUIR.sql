
/****** Object:  Stored Procedure dbo.SPVE_REPRESENTANTES_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_REPRESENTANTES_INCLUIR    Script Date: 25/08/1999 20:11:37 ******/
CREATE PROCEDURE SPVE_REPRESENTANTES_INCLUIR

    @Codigo        char(3),
	@RazaoSocial   varchar(50),
	@Endereco      varchar(50),
    @Bairro        varchar(25),
	@Cidade        varchar(25),
    @Estado        char(2),
	@Cep           char(9),
    @DDD           char(4),
    @Telefone      char(10),
    @Celular       char(10),
    @PagerNumero   char(10),
    @PagerCodigo   char(10),
    @Fax           char(10),
    @Email         varchar(50),
    @Contato       varchar(25),
    @Comissao      numeric(6,3),
	@CotaMensal    money,
    @CGC           char(14),
    @Inscricao     char(14)

AS

BEGIN

	INSERT INTO VE_Representantes (verp_Codigo,
                                   verp_RazaoSocial,
	                               verp_Endereco,
	                               verp_Bairro,
	                               verp_Cidade,
	                               verp_Estado,
                                   verp_Cep,
	                               verp_DDD,
                                   verp_Telefone,
                                   verp_Celular,
                                   verp_PagerNumero,
                                   verp_PagerCodigo,
                                   verp_Fax,
                                   verp_Email,
                                   verp_Contato,
                                   verp_Comissao,
                                   verp_CotaMensal,
                                   verp_CGC,
                                   verp_Inscricao)
                                    
		                    VALUES (@Codigo,
                                    @RazaoSocial,
	                                @Endereco,
	                                @Bairro,
	                                @Cidade,
	                                @Estado,
                                    @Cep,
	                                @DDD,
                                    @Telefone,
                                    @Celular,
                                    @PagerNumero,
                                    @PagerCodigo,
                                    @Fax,
                                    @Email,
                                    @Contato,
                                    @Comissao,
                                    @CotaMensal,
                                    @CGC,
                                    @Inscricao)

END


   

	       

         


