
/****** Object:  Stored Procedure dbo.SPVE_TRANSPORTADORAS_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/

/****** Object:  Stored Procedure dbo.SPVE_TRANSPORTADORAS_ALTERAR    Script Date: 25/08/1999 20:11:37 ******/
CREATE PROCEDURE SPVE_TRANSPORTADORAS_ALTERAR

    @Codigo        int,
	@CGC           char(14),
    @Abreviado     char(14),
	@Nome          varchar(50),
	@Endereco      varchar(50),
    @Bairro        varchar(25),
	@Cidade        varchar(25),
    @Estado        char(2),
	@Cep           char(9),
    @DDD           char(4),
    @Telefone      char(10),
    @Fax           char(10),
    @Email         varchar(50),
    @Contato       varchar(25),
    @Inscricao     char(14)
   

AS

BEGIN

	UPDATE VE_Transportadoras
	   SET vetr_CGC         = @CGC,
           vetr_Abreviado   = @Abreviado,
           vetr_Nome        = @Nome,
	       vetr_Endereco    = @Endereco,
	       vetr_Bairro      = @Bairro,
	       vetr_Cidade      = @Cidade,
	       vetr_Estado      = @Estado,
           vetr_Cep         = @Cep,
	       vetr_DDD         = @DDD,
           vetr_Telefone    = @Telefone,
           vetr_Fax         = @Fax,
           vetr_Email       = @Email,
           vetr_Contato     = @Contato,
           vetr_Inscricao   = @Inscricao
          
         WHERE vetr_Codigo = @Codigo

END



