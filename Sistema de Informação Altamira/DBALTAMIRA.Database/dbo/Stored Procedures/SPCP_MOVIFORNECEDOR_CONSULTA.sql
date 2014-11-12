
/****** Object:  Stored Procedure dbo.SPCP_MOVIFORNECEDOR_CONSULTA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_MOVIFORNECEDOR_CONSULTA    Script Date: 25/08/1999 20:11:54 ******/
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
                                   cofc_Nome char(40) Null,
		        cpnd_DataPagamento smallDateTime Null)      


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
           cofc_Nome,
           cpnd_DataPagamento      
     
      FROM CP_NotaFiscal,
           CP_NotaFiscalDetalhe,
           CO_Fornecedor

     WHERE cpnd_DataVencimento <= @DataFinal
       AND cpnd_DataVencimento >= @DataInicial
       AND cpnf_NotaFiscal = cpnd_NotaFiscal
       AND cpnf_Fornecedor = cpnd_Fornecedor
       AND cpnf_TipoNota = cpnd_TipoNota
       AND cpnf_Fornecedor = cofc_Codigo
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
           cofc_Nome,
           cpsp_DataPagamento       
     
      FROM CP_SinalPedido,
           CO_Pedido,
           CO_Fornecedor

     WHERE cope_Data <= @DataFinal
       AND (cpsp_DataPagamento IS NULL OR cpsp_DataPagamento > @DataFinal)
       AND cpsp_Pedido = cope_Numero
       AND cofc_Codigo = cope_Fornecedor


    SELECT * FROM #TabMovFornecedor ORDER BY cofc_Nome

END








