
/****** Object:  Stored Procedure dbo.SPVE_CLIENTES_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_CLIENTES_INCLUIR    Script Date: 25/08/1999 20:11:44 ******/
CREATE PROCEDURE SPVE_CLIENTES_INCLUIR

    @Codigo          char(14),
    @Abreviado       char(14),
    @Nome            varchar(50),
    @Endereco        varchar(50),
    @Bairro          varchar(25),
    @Cidade          varchar(25),
    @Estado          char(2),
    @Municipio       char(25),
    @Cep             char(9),
    @Inscricao       char(14),
    @Contato         varchar(20),
    @Departamento    varchar(20),
    @Telefone        char(10),
    @Fax             char(10),
    @DDD             char(4),
    @Representante   char(3),
    @Observacao      varchar(50),
    @Credito         varchar(50),
    @Email           varchar(40),
    @TipoPessoa      char(1),
    @Transportadora  int,
    @UltimaCompra    smalldatetime,
    @NumeroRG        varchar(12),
    @DataNascimento  smalldatetime,
    @CobEndereco     varchar(40),
    @CobBairro       varchar(25),
    @CobCidade       varchar(25),
    @CobEstado       varchar(2),
    @CobCep          varchar(9),
    @CobDDD          varchar(4),
    @CobTelefone     varchar(10),
    @CobFax          varchar(10),
    @CobEmail        varchar(40)

AS

BEGIN

  INSERT INTO VE_ClientesNovo (vecl_Codigo,
                           vecl_Abreviado,
                           vecl_Nome,
	              vecl_Endereco,
	              vecl_Bairro,
	              vecl_Cidade,
	              vecl_Estado,
	              vecl_Municipio,
                           vecl_Cep,
                           vecl_Inscricao,
                           vecl_Contato,
                           vecl_Departamento, 
                           vecl_Telefone,
                           vecl_Fax,
	              vecl_DDD,
                           vecl_Representante,
                           vecl_Observacao,
                           vecl_Credito,
                           vecl_Email,
                           vecl_TipoPessoa,
                           vecl_Transportadora,
                           vecl_UltimaCompra,
                           vecl_NumeroRG,
                           vecl_DataNascimento,
                           vecl_CobEndereco,      
	              vecl_CobBairro,        
	              vecl_CobCidade,       
	              vecl_CobEstado, 
                           vecl_CobCep,         
                           vecl_CobDDD,           
                           vecl_CobTelefone,      
                           vecl_CobFax,         
                           vecl_CobEmail)
                            
            VALUES (@Codigo,
                            @Abreviado,
                            @Nome,
	               @Endereco,
	               @Bairro,
	               @Cidade,
	               @Estado,
	               @Municipio,
                            @Cep,
                            @Inscricao,
                            @Contato,
                            @Departamento,
                            @Telefone,
                            @Fax,
	               @DDD,
                            @Representante,
                            @Observacao,
                            @Credito,
                            @Email,
                            @TipoPessoa,
                            @Transportadora,
                            @UltimaCompra,
                            @NumeroRG,
                            @DataNascimento,
                            @CobEndereco,
	               @CobBairro,
	               @CobCidade,
	               @CobEstado,
                            @CobCep, 
                            @CobDDD,
                            @CobTelefone,
                            @CobFax,
                            @CobEmail)

END


   

	       

         





