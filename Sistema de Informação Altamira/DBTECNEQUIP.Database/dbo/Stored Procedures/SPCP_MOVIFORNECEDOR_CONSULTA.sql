
/****** Object:  Stored Procedure dbo.SPCP_MOVIFORNECEDOR_CONSULTA    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCP_MOVIFORNECEDOR_CONSULTA    Script Date: 16/10/01 13:41:51 ******/
/****** Object:  Stored Procedure dbo.SPCP_MOVIFORNECEDOR_CONSULTA    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCP_MOVIFORNECEDOR_CONSULTA
   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime
    
AS

BEGIN

    CREATE TABLE #TabMovFornecedor(cpnf_DataEntrada  smalldatetime  Null,
                                   cpnf_NotaFiscal   char(6) Null,
                                   cpnf_Parcelas     smallint Null,
                                   cpnd_Duplicata    char(6) Null,
                                   cpnd_Parcela      smallint Null,
                                   cpnd_DataVencimento smalldatetime Null,
                                   cpnd_DataProrrogacao smalldatetime Null,
                                   cpnd_ValorTotal money Null,
                                   cofc_Nome char(40) Null)      


    -- Insere os dados do fornecedor 
    INSERT INTO #TabMovFornecedor

    SELECT cpnf_DataEntrada,
           cpnf_NotaFiscal,
           cpnf_Parcelas,
           cpnd_Duplicata,
           cpnd_Parcela,
           cpnd_DataVencimento,
           cpnd_DataProrrogacao,
           cpnd_ValorTotal,
           cofc_Nome       
     
      FROM CP_NotaFiscal,
           CP_NotaFiscalDetalhe,
           CO_Fornecedor

     WHERE cpnf_DataEntrada <= @DataFinal
       AND cpnf_NotaFiscal = cpnd_NotaFiscal
       AND cpnf_Fornecedor = cpnd_Fornecedor
       AND cpnf_TipoNota = cpnd_TipoNota
       AND cpnf_Fornecedor = cofc_Codigo
       AND (cpnd_DataPagamento IS NULL OR cpnd_DataPagamento > @DataFinal) 
       

    -- Insere os dados do fornecedor 
    INSERT INTO #TabMovFornecedor

    SELECT cope_Data,
           'Sinal',
           1,
           '----',
           1,
           cpsp_DataVencimento,
           cpsp_DataVencimento,
           cpsp_Valor,
           cofc_Nome       
     
      FROM CP_SinalPedido,
           CO_Pedido,
           CO_Fornecedor

     WHERE cope_Data <= @DataFinal
       AND (cpsp_DataPagamento IS NULL OR cpsp_DataPagamento > @DataFinal)
       AND cpsp_Pedido = cope_Numero
       AND cofc_Codigo = cope_Fornecedor


    SELECT * FROM #TabMovFornecedor ORDER BY cofc_Nome

END




