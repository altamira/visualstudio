
/****** Object:  Stored Procedure dbo.SPVE_REPRESENTANTES_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_REPRESENTANTES_ALTERAR    Script Date: 25/08/1999 20:11:36 ******/
CREATE PROCEDURE SPVE_REPRESENTANTES_ALTERAR
	
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

	UPDATE VE_Representantes
	   SET verp_RazaoSocial = @RazaoSocial,
	       verp_Endereco    = @Endereco,
	       verp_Bairro      = @Bairro,
	       verp_Cidade      = @Cidade,
	       verp_Estado      = @Estado,
           verp_Cep         = @Cep,
	       verp_DDD         = @DDD,
           verp_Telefone    = @Telefone,
           verp_Celular     = @Celular,
           verp_PagerNumero = @PagerNumero,
           verp_PagerCodigo = @PagerCodigo,
           verp_Fax         = @Fax,
           verp_Email       = @Email,
           verp_Contato     = @Contato,
           verp_Comissao    = @Comissao,
           verp_CotaMensal  = @CotaMensal,
           verp_CGC         = @CGC,
           verp_Inscricao   = @Inscricao 

         WHERE verp_Codigo = @Codigo

END

