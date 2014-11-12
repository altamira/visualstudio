
/****** Object:  Stored Procedure dbo.SPCP_PENDENTESFORNEC_CONSULTA    Script Date: 23/10/2010 15:32:29 ******/


/****** Object:  Stored Procedure dbo.SPCP_PENDENTESFORNEC_CONSULTA    Script Date: 25/08/1999 20:11:55 ******/
CREATE PROCEDURE SPCP_PENDENTESFORNEC_CONSULTA
   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime
    
AS

BEGIN

    CREATE TABLE #TabMovFornecedor(cpnf_NotaFiscal   char(6) Null,
                                   cpnf_Parcelas     smallint Null,
                                   cpnd_Parcela      smallint Null,
                                   cpnd_DataVencimento smalldatetime Null,
                                   cpnd_DataProrrogacao smalldatetime Null,
                                   cpnd_ValorTotal money Null,
                                   cofc_Nome char(40) Null)      


    -- Insere os dados do fornecedor 
    INSERT INTO #TabMovFornecedor

    SELECT cpnf_NotaFiscal,
           cpnf_Parcelas,
           cpnd_Parcela,
           cpnd_DataVencimento,
           cpnd_DataProrrogacao,
           cpnd_ValorTotal,
           cofc_Nome       
     
      FROM CP_NotaFiscal,
           CP_NotaFiscalDetalhe,
           CO_Fornecedor

     WHERE cpnd_DataPagamento is NULL
       AND cpnd_DataProrrogacao is NULL
       AND cpnd_DataVencimento BETWEEN @DataInicial AND @DataFinal
       AND cpnf_NotaFiscal = cpnd_NotaFiscal
       AND cpnf_Fornecedor = cpnd_Fornecedor
       AND cpnf_TipoNota = cpnd_TipoNota
       AND cpnf_Fornecedor = cofc_Codigo
              

    INSERT INTO #TabMovFornecedor

    SELECT cpnf_NotaFiscal,
           cpnf_Parcelas,
           cpnd_Parcela,
           cpnd_DataVencimento,
           cpnd_DataProrrogacao,
           cpnd_ValorTotal,
           cofc_Nome       
     
      FROM CP_NotaFiscal,
           CP_NotaFiscalDetalhe,
           CO_Fornecedor

     WHERE cpnd_DataPagamento is NULL
       AND cpnd_DataProrrogacao BETWEEN @DataInicial AND @DataFinal
       AND cpnf_NotaFiscal = cpnd_NotaFiscal
       AND cpnf_Fornecedor = cpnd_Fornecedor
       AND cpnf_TipoNota = cpnd_TipoNota
       AND cpnf_Fornecedor = cofc_Codigo


    SELECT * FROM #TabMovFornecedor ORDER BY cpnd_DataVencimento

END





