
/****** Object:  Stored Procedure dbo.SPCP_CONTACORRENTEFOR_CONSULTA    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCP_CONTACORRENTEFOR_CONSULTA    Script Date: 16/10/01 13:41:51 ******/
/****** Object:  Stored Procedure dbo.SPCP_CONTACORRENTEFOR_CONSULTA    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCP_CONTACORRENTEFOR_CONSULTA

@DataInicial   smalldatetime,
@DataFinal     smalldatetime,
@Fornecedor    char(14)

AS

BEGIN

    CREATE TABLE #TabFornecedor (cofc_Codigo  char(14) Null,
                                 cofc_Nome    char(40) Null,
                                 cofc_Endereco char(40) Null,
                                 cofc_Bairro char(25) Null,
                                 cofc_Cep char(9) Null,
                                 cofc_Cidade char(25) Null,
                                 cofc_Estado char(2) Null,
                                 cofc_TipoPessoa char(1) Null,
                                 cofc_Inscricao char(12) Null,
                                 cofc_DDDTelefone char(4) Null,
                                 cofc_Telefone Char(10) Null,
                                 cofc_DDDFax char(4) Null,
                                 cofc_Fax Char(10) Null,
                                 cpnf_NotaFiscal char(6) Null,
                                 cpnf_DataEntrada smalldatetime Null,
                                 cpnd_Duplicata char(6) Null,
                                 cpnd_DataVencimento smalldatetime Null, 
                                 cpnd_DataProrrogacao smalldatetime Null,
                                 cpnd_ValorTotal money Null,
                                 cpnd_DataPagamento smalldatetime Null,
                                 cpnd_BancoPagamento char(3) Null,
                                 cpnd_CopiaCheque int Null,
                                 cpnd_Observacao varchar(50) Null)


    INSERT INTO #TabFornecedor

    select cofc_Codigo,
           cofc_Nome,
           cofc_Endereco,
           cofc_Bairro,
           cofc_Cep,
           cofc_Cidade,
           cofc_Estado,
           cofc_TipoPessoa,
           cofc_Inscricao,
           cofc_DDDTelefone,
           cofc_Telefone,
           cofc_DDDFax,
           cofc_Fax,
           cpnf_NotaFiscal,
           cpnf_DataEntrada,
           cpnd_Duplicata,
           cpnd_DataVencimento,
           cpnd_DataProrrogacao,
           cpnd_ValorTotal,
           cpnd_DataPagamento,
           cpnd_BancoPagamento,
           cpnd_CopiaCheque,
           cpnd_Observacao
      
        From CO_Fornecedor,
             CP_NotaFiscal,
             CP_NotaFiscalDetalhe

        Where cofc_Codigo = @Fornecedor
          AND cofc_Codigo = cpnf_Fornecedor
          AND cpnf_Fornecedor = cpnd_Fornecedor
          AND cpnf_NotaFiscal = cpnd_NotaFiscal
          AND cpnf_TipoNota = cpnd_TipoNota
          AND cpnf_DataEntrada BETWEEN @DataInicial AND @DataFinal

    INSERT INTO #TabFornecedor

    select cofc_Codigo,
           cofc_Nome,
           cofc_Endereco,
           cofc_Bairro,
           cofc_Cep,
           cofc_Cidade,
           cofc_Estado,
           cofc_TipoPessoa,
           cofc_Inscricao,
           cofc_DDDTelefone,
           cofc_Telefone,
           cofc_DDDFax,
           cofc_Fax,
           'Sinal',
           cope_Data,
           '-----',
           cpsp_DataVencimento,
           cpsp_DataVencimento,
           cpsp_Valor,
           cpsp_DataPagamento,
           cpsp_BancoPagamento,
           cpsp_CopiaCheque,
           cpsp_Observacao
      
        From CO_Fornecedor,
             CP_SinalPedido,
             CO_Pedido


        Where cofc_Codigo = @Fornecedor
          AND cope_Fornecedor = cofc_Codigo
          AND cpsp_Pedido = cope_Numero
          AND cope_Data BETWEEN @DataInicial AND @DataFinal
    

    SELECT * From #TabFornecedor

END
	

