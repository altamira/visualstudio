
/****** Object:  Stored Procedure dbo.SPCO_FORNECEDOR_ALTERAR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_FORNECEDOR_ALTERAR    Script Date: 16/10/01 13:41:44 ******/
/****** Object:  Stored Procedure dbo.SPCO_FORNECEDOR_ALTERAR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCO_FORNECEDOR_ALTERAR
	
	@Codigo        char(14),
	@Abreviado     char(14),
	@Nome          char(40),
	@Endereco      char(40),
	@Bairro	       char(25),
	@Cidade        char(25),
	@Estado        char(2),
	@Cep           char(9),
	@Inscricao     char(12),
	@TipoPessoa    char(1),    -- Física -> F or Jurídica -> J
	@Contato       char(20),
	@Telefone      char(10),
	@DDDTelefone   char(4),
	@Fax	         char(10),
	@DDDFax        char(4),
	@Email         char(40),
   @CodigoServico tinyint,
	@CodigoPasta   tinyint,
	@Observacao    varchar(50)	

AS


BEGIN

	UPDATE CO_Fornecedor
	   SET cofc_Abreviado   = @Abreviado,
	       cofc_Nome        = @Nome,
	       cofc_Endereco    = @Endereco,
	       cofc_Bairro      = @Bairro,
	       cofc_Cidade      = @Cidade,
	       cofc_Estado      = @Estado,
	       cofc_Cep         = @Cep,
	       cofc_Inscricao   = @Inscricao,
	       cofc_TipoPessoa  = @TipoPessoa,
	       cofc_Contato     = @Contato,
	       cofc_Telefone    = @Telefone,
	       cofc_DDDTelefone = @DDDTelefone,
		    cofc_Fax         = @Fax,
	       cofc_DDDFax      = @DDDFax,
	       cofc_Email       = @Email,
          cofc_Servico     = @CodigoServico,
	       cofc_Pasta       = @CodigoPasta,
	       cofc_Observacao  = @Observacao
         WHERE cofc_Codigo = @Codigo

END


