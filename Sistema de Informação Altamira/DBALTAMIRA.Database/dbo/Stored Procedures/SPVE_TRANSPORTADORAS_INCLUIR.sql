
/****** Object:  Stored Procedure dbo.SPVE_TRANSPORTADORAS_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_TRANSPORTADORAS_INCLUIR    Script Date: 25/08/1999 20:11:37 ******/
CREATE PROCEDURE SPVE_TRANSPORTADORAS_INCLUIR

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

	INSERT INTO VE_Transportadoras(vetr_Codigo,
                                   vetr_CGC,
                                   vetr_Abreviado,
                                   vetr_Nome,
	                               vetr_Endereco,
	                               vetr_Bairro,
	                               vetr_Cidade,
	                               vetr_Estado,
                                   vetr_Cep,
	                               vetr_DDD,
                                   vetr_Telefone,
                                   vetr_Fax,
                                   vetr_Email,
                                   vetr_Contato,
                                   vetr_Inscricao)
                                    
		                    VALUES (@Codigo,
                                    @CGC,
                                    @Abreviado,
                                    @Nome,
	                                @Endereco,
	                                @Bairro,
	                                @Cidade,
	                                @Estado,
                                    @Cep,
	                                @DDD,
                                    @Telefone,
                                    @Fax,
                                    @Email,
                                    @Contato,
                                    @Inscricao)

END


   

	       

         


