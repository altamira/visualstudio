
/****** Object:  Stored Procedure dbo.SPCP_PENDENTESIMPOSTO_CONSULTA    Script Date: 23/10/2010 15:32:29 ******/


/****** Object:  Stored Procedure dbo.SPCP_PENDENTESIMPOSTO_CONSULTA    Script Date: 25/08/1999 20:11:49 ******/
CREATE PROCEDURE SPCP_PENDENTESIMPOSTO_CONSULTA
   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime
    
AS

BEGIN

    CREATE TABLE #TabMovImposto(cpde_Descricao    char(40) Null,
                                cpdi_Parcelas     smallint Null,
                                cpdd_Parcela      smallint Null,
                                cpdd_DataVencimento smalldatetime Null,
                                cpdd_DataProrrogacao smalldatetime Null,
                                cpdd_ValorTotal money Null)      


    -- Insere os dados do fornecedor 
    INSERT INTO #TabMovImposto

    SELECT cpde_Descricao,
           cpdi_Parcelas,
           cpdd_Parcela,
           cpdd_DataVencimento,
           cpdd_DataProrrogacao,
           cpdd_ValorTotal
     
      FROM CP_DespesaImposto,
           CP_DespesaImpostoDetalhe,
           CP_Descricao

     WHERE cpdi_TipoConta = 'I'
       AND cpdd_DataPagamento is NULL
       AND cpdd_DataProrrogacao is NULL
       AND cpdd_DataVencimento BETWEEN @DataInicial AND @DataFinal
       AND cpdi_Sequencia = cpdd_Sequencia
       AND cpdi_CodigoConta = cpde_Codigo
       AND cpde_Tipo = 'I'
                            

    INSERT INTO #TabMovImposto

    SELECT cpde_Descricao,
           cpdi_Parcelas,
           cpdd_Parcela,
           cpdd_DataVencimento,
           cpdd_DataProrrogacao,
           cpdd_ValorTotal
     
      FROM CP_DespesaImposto,
           CP_DespesaImpostoDetalhe,
           CP_Descricao

     WHERE cpdi_TipoConta = 'I'
       AND cpdd_DataPagamento is NULL
       AND cpdd_DataProrrogacao BETWEEN @DataInicial AND @DataFinal
       AND cpdi_Sequencia = cpdd_Sequencia
       AND cpdi_CodigoConta = cpde_Codigo
       AND cpde_Tipo = 'I'


     -- Previsao
     INSERT INTO #TabMovImposto

     SELECT cpde_Descricao,
            NULL,
            NULL,
            cppr_DataVencimento,
            NULL,
            cppr_Valor
     
      FROM CP_Previsao,
           CP_Descricao

     WHERE cppr_Tipo = 'I'
       AND cppr_DataVencimento BETWEEN @DataInicial AND @DataFinal
       AND cppr_Descricao = cpde_Codigo
       AND cpde_Tipo = 'I'


    SELECT * FROM #TabMovImposto ORDER BY cpdd_DataVencimento

END





