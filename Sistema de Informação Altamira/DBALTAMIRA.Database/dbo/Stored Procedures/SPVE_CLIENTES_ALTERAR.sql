
/****** Object:  Stored Procedure dbo.SPVE_CLIENTES_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/
/****** Object:  Stored Procedure dbo.SPVE_CLIENTES_ALTERAR    Script Date: 25/08/1999 20:11:44 ******/
CREATE PROCEDURE SPVE_CLIENTES_ALTERAR
	@Codigo          char(14),
	@Abreviado       char(14),
	@Nome            varchar(50),
	@Endereco        varchar(50),
    	@Bairro          varchar(25),
	@Cidade          varchar(25),
    	@Estado          char(2),
    	@Municipio        char(25),
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

	UPDATE VE_ClientesNovo

	   SET vecl_Abreviado      = @Abreviado,
           vecl_Nome           = @Nome,
	       vecl_Endereco       = @Endereco,
	       vecl_Bairro         = @Bairro,
	       vecl_Cidade         = @Cidade,
	       vecl_Estado         = @Estado,
	       vecl_Municipio      = @Municipio,
           vecl_Cep            = @Cep,
           vecl_Inscricao      = @Inscricao,
           vecl_Contato        = @Contato,
           vecl_Departamento   = @Departamento, 
           vecl_Telefone       = @Telefone,
           vecl_Fax            = @Fax,
	       vecl_DDD            = @DDD,
           vecl_Representante  = @Representante,
           vecl_Observacao     = @Observacao,
           vecl_Credito        = @Credito,
           vecl_Email          = @Email,
           vecl_TipoPessoa     = @TipoPessoa,
           vecl_Transportadora = @Transportadora,
           vecl_UltimaCompra   = @UltimaCompra,
           vecl_NumeroRG       = @NumeroRG,
           vecl_DataNascimento = @DataNascimento,
           vecl_CobEndereco    = @CobEndereco,
	       vecl_CobBairro      = @CobBairro,
	       vecl_CobCidade      = @CobCidade,
	       vecl_CobEstado      = @CobEstado,
           vecl_CobCep         = @CobCep,
           vecl_CobDDD         = @CobDDD,
           vecl_CobTelefone    = @CobTelefone,
           vecl_CobFax         = @CobFax,
           vecl_CobEmail       = @CobEmail

             WHERE vecl_Codigo = @Codigo

END






