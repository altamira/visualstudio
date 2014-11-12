
/****** Object:  Stored Procedure dbo.SPVE_RECADOS_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_RECADOS_ALTERAR    Script Date: 25/08/1999 20:11:44 ******/
CREATE PROCEDURE SPVE_RECADOS_ALTERAR
    @Numero        int,
    @Data          smalldatetime,
    @Abreviado     char(14),
    @Nome          varchar(40),
    @Endereco      varchar(40),
    @Bairro        varchar(25),	
    @Cidade        varchar(25),
    @Estado        char(2),
    @Municipio       varchar(25),
    @DDD           char(4),
    @Telefone      char(25),
    @DDDFax      char(4),
    @NumeroFax  char(25),
    @Contato       varchar(25),
    @ProcurarPor   varchar(25),
    @Departamento  varchar(20),
    @Representante char(3),
    @Propaganda    tinyint,
    @Produto       tinyint,
    @Chamado       tinyint,
    @Observacao    varchar(100),
    @EMail               varchar(30)

AS

BEGIN

	UPDATE VE_Recados
	        SET vere_Data          = @Data,
		   vere_Abreviado     = @Abreviado,
           		   vere_Nome          = @Nome,
	       	   vere_Endereco      = @Endereco,
	       	   vere_Bairro        = @Bairro,
	       	    vere_Cidade        = @Cidade,
	       	    vere_Estado        = @Estado,
	       	    vere_Municipio     = @Municipio,
           		    vere_DDD           = @DDD,
           		    vere_Telefone      = @Telefone,
		    vere_DDDFax      = @DDDFax,
		    vere_NumeroFax  = @NumeroFax,
           		    vere_Contato       = @Contato,
           		    vere_ProcurarPor   = @ProcurarPor,
           		    vere_Departamento  = @Departamento,
            		    vere_Representante = @Representante,
           		    vere_Propaganda    = @Propaganda,
           		    vere_Produto       = @Produto,
           		    vere_Chamado       = @Chamado,
           		    vere_Observacao    = @Observacao,
		    vere_EMail	         = @EMail
            WHERE     vere_Numero = @Numero

END





