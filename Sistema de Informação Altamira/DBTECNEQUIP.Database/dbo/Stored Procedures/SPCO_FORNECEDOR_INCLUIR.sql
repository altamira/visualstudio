
/****** Object:  Stored Procedure dbo.SPCO_FORNECEDOR_INCLUIR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_FORNECEDOR_INCLUIR    Script Date: 16/10/01 13:41:45 ******/
/****** Object:  Stored Procedure dbo.SPCO_FORNECEDOR_INCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCO_FORNECEDOR_INCLUIR

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


	INSERT INTO CO_Fornecedor (cofc_Codigo,
			       cofc_Abreviado,
				   cofc_Nome,
				   cofc_Endereco,
				   cofc_Bairro,
				   cofc_Cidade,
				   cofc_Estado,
				   cofc_Cep,
				   cofc_Inscricao,
				   cofc_TipoPessoa,
				   cofc_Contato,
				   cofc_Telefone,
				   cofc_DDDTelefone,
				   cofc_Fax,
				   cofc_DDDFax,
				   cofc_Email,
               cofc_Servico,
				   cofc_Pasta,
				   cofc_Observacao)
		      VALUES (@Codigo,
			      @Abreviado,
			      @Nome,
			      @Endereco,
			      @Bairro,
			      @Cidade,
			      @Estado,
			      @Cep,
			      @Inscricao,
			      @TipoPessoa,
			      @Contato,
			      @Telefone,
				   @DDDTelefone,
			      @Fax,
			      @DDDFax,
				   @Email,
               @CodigoServico,
			      @CodigoPasta,
			      @Observacao)

END

