
/****** Object:  Stored Procedure dbo.SPVE_RECADOS_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/
/****** Object:  Stored Procedure dbo.SPVE_RECADOS_INCLUIR    Script Date: 25/08/1999 20:11:44 ******/
CREATE PROCEDURE SPVE_RECADOS_INCLUIR
    @Numero        int,
    @Data          smalldatetime,
    @Abreviado     char(14),
    @Nome          varchar(40),
    @Endereco      varchar(40),
    @Bairro        varchar(25),
    @Cidade        varchar(25),
    @Estado        char(2),
    @Municipio     char(25),
    @DDD           char(4),
    @Telefone      char(25),
    @DDDFax      char(4),
    @NumeroFax char(25),
    @Contato       varchar(25),
    @ProcurarPor   varchar(25),
    @Departamento  varchar(20),
    @Representante char(3),
    @Propaganda    tinyint,
    @Produto       tinyint,
    @Chamado         tinyint,
    @Observacao    varchar(100),
    @Email                 Varchar(30)

AS

BEGIN
   INSERT INTO VE_Recados(vere_Numero,
                           vere_Data,
                           vere_Abreviado,
                           vere_Nome,           
	              vere_Endereco,      
	              vere_Bairro,        
	              vere_Cidade,       
	              vere_Estado,       
	              vere_Municipio,       
                           vere_DDD,           
                           vere_Telefone,
  		vere_DDDFax,
		vere_NumeroFax,      
                           vere_Contato,
                           vere_ProcurarPor,        
                           vere_Departamento,   
                           vere_Representante, 
                           vere_Propaganda,
                           vere_Produto,
                           vere_Chamado,   
                           vere_Observacao,
		vere_EMail)     
           VALUES (@Numero,
		@Data,
	             @Abreviado,
	             @Nome,
	             @Endereco,
                          @Bairro,
	             @Cidade,
                          @Estado,
                          @Municipio,
	             @DDD,
		@Telefone,
		@DDDFax,
		@NumeroFax,
		@Contato,
		@ProcurarPor,
		@Departamento,
		@Representante,
		@Propaganda,
		@Produto,
		@Chamado,
		@Observacao,
		@EMail)

END



