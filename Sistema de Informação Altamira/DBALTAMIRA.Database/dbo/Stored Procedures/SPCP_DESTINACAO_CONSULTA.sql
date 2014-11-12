
/****** Object:  Stored Procedure dbo.SPCP_DESTINACAO_CONSULTA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_DESTINACAO_CONSULTA    Script Date: 25/08/1999 20:11:48 ******/
CREATE PROCEDURE SPCP_DESTINACAO_CONSULTA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime

AS
	
   DECLARE @TotalFolha         money,
           @TotalPrestacao     money,
           @TotalTransporte    money,
           @TotalDespesa       money,
           @TotalFornecedor    money,
           @TotalImobilizado   money,
           @TotalManutencao    money,
           @TotalImposto       money

BEGIN

   -- Folha
   SELECT @TotalFolha = SUM(cpdd_ValorTotal)
      FROM CP_DespesaImpostoDetalhe
           WHERE cpdd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpdd_Grupo = 1
   SELECT @TotalFolha = IsNull(@TotalFolha, 0) + IsNull(SUM(cpnd_ValorTotal), 0)
      FROM CP_NotaFiscalDetalhe
           WHERE cpnd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpnd_Grupo = 1

   -- Prestacao
   SELECT @TotalPrestacao = SUM(cpdd_ValorTotal)
      FROM CP_DespesaImpostoDetalhe
           WHERE cpdd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpdd_Grupo = 2
   SELECT @TotalPrestacao = IsNull(@TotalPrestacao, 0) + IsNull(SUM(cpnd_ValorTotal), 0)
      FROM CP_NotaFiscalDetalhe
           WHERE cpnd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpnd_Grupo = 2

   -- Transporte
   SELECT @TotalTransporte = SUM(cpdd_ValorTotal)
      FROM CP_DespesaImpostoDetalhe
           WHERE cpdd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpdd_Grupo = 3
   SELECT @TotalTransporte = IsNull(@TotalTransporte, 0) + IsNull(SUM(cpnd_ValorTotal), 0)
       FROM CP_NotaFiscalDetalhe
           WHERE cpnd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpnd_Grupo = 3

   -- Despesa
   SELECT @TotalDespesa = SUM(cpdd_ValorTotal)
      FROM CP_DespesaImpostoDetalhe
           WHERE cpdd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpdd_Grupo = 4
   SELECT @TotalDespesa = IsNull(@TotalDespesa, 0) + IsNull(SUM(cpnd_ValorTotal), 0)
      FROM CP_NotaFiscalDetalhe
           WHERE cpnd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpnd_Grupo = 4

   -- Fornecedor
   SELECT @TotalFornecedor = SUM(cpdd_ValorTotal)
      FROM CP_DespesaImpostoDetalhe
           WHERE cpdd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpdd_Grupo = 5
   SELECT @TotalFornecedor = IsNull(@TotalFornecedor, 0) + IsNull(SUM(cpnd_ValorTotal), 0)
      FROM CP_NotaFiscalDetalhe
           WHERE cpnd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpnd_Grupo = 5

   -- Imobilizado
   SELECT @TotalImobilizado = SUM(cpdd_ValorTotal)
      FROM CP_DespesaImpostoDetalhe
           WHERE cpdd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpdd_Grupo = 6
   SELECT @TotalImobilizado = IsNull(@TotalImobilizado, 0) + IsNull(SUM(cpnd_ValorTotal), 0)
      FROM CP_NotaFiscalDetalhe
           WHERE cpnd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpnd_Grupo = 6

   -- Manutencao
   SELECT @TotalManutencao = SUM(cpdd_ValorTotal)
      FROM CP_DespesaImpostoDetalhe
           WHERE cpdd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpdd_Grupo = 7
   SELECT @TotalManutencao = IsNull(@TotalManutencao, 0) + IsNull(SUM(cpnd_ValorTotal), 0)
      FROM CP_NotaFiscalDetalhe
           WHERE cpnd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpnd_Grupo = 7

   -- Imposto
   SELECT @TotalImposto = SUM(cpdd_ValorTotal)
      FROM CP_DespesaImpostoDetalhe
           WHERE cpdd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpdd_Grupo = 8
   SELECT @TotalImposto = IsNull(@TotalImposto, 0) + IsNull(SUM(cpnd_ValorTotal), 0)
      FROM CP_NotaFiscalDetalhe
           WHERE cpnd_DataPagamento BETWEEN @DataInicial AND @DataFinal
             AND cpnd_Grupo = 8

   CREATE TABLE #TabDestinacao(Descricao varchar(25),
                               Total     money)

   INSERT INTO #TabDestinacao Values ('Folha Pagamento', ISNULL(@TotalFolha, 0))
   INSERT INTO #TabDestinacao Values ('Prestação Serviço', ISNULL(@TotalPrestacao, 0))
   INSERT INTO #TabDestinacao Values ('Transporte', ISNULL(@TotalTransporte, 0))
   INSERT INTO #TabDestinacao Values ('Despesas Gerais', ISNULL(@TotalDespesa, 0))
   INSERT INTO #TabDestinacao Values ('Fornecedor', ISNULL(@TotalFornecedor, 0))
   INSERT INTO #TabDestinacao Values ('Imobilizado', ISNULL(@TotalImobilizado, 0))
   INSERT INTO #TabDestinacao Values ('Manutenção', ISNULL(@TotalManutencao, 0))
   INSERT INTO #TabDestinacao Values ('Imposto', ISNULL(@TotalImposto, 0))

   SELECT * FROM #TabDestinacao
      
END


