
/****** Object:  Stored Procedure dbo.SPCP_ANALITICOMENSAL_RELATORIO    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_ANALITICOMENSAL_RELATORIO    Script Date: 25/08/1999 20:11:47 ******/
CREATE PROCEDURE SPCP_ANALITICOMENSAL_RELATORIO

@MesAno           char(7)
         
AS
	
Declare  @DataInicial    Smalldatetime,
         @DataFinal      Smalldatetime

Begin

    -- Define Data inicial
    SELECT @DataInicial = SUBSTRING(@MesAno, 1, 2) + '/01/' +  SUBSTRING(@MesAno, 4, 4)

    -- Define Data Final
    SELECT @DataFinal = DATEADD(Month, 1, @DataInicial)

    SELECT @DataFinal = DATEADD(Day, -1, @DataFinal)


    Create Table #TotalGrupo(DescricaoGrupo   char(30)  null,
                             DescricaoSubGrupo  char(30) null,
                             ValorTotal money null)


    -- coloca valores da despesa imposto
    INSERT INTO #TotalGrupo (DescricaoGrupo,
                             DescricaoSubGrupo,
                             ValorTotal)

    SELECT cpgr_DescricaoGrupo,
           cpsg_Descricao,
           cpdd_ValorTotal
      
      FROM CP_Grupo,
           CP_SubGrupo,
           CP_DespesaImpostoDetalhe

     WHERE cpdd_DataPagamento BETWEEN @DataInicial AND @DataFinal
       AND cpdd_Destinacao  = cpsg_Codigo
       AND cpdd_Grupo       = cpsg_Grupo
       AND cpgr_CodigoGrupo = cpsg_Grupo


    -- coloca valores de Fornecedor
    INSERT INTO #TotalGrupo (DescricaoGrupo,
                             DescricaoSubGrupo,
                             ValorTotal)

    SELECT cpgr_DescricaoGrupo,
           cpsg_Descricao,
           cpnd_ValorTotal
      
      FROM CP_Grupo,
           CP_SubGrupo,
           CP_NotaFiscalDetalhe

     WHERE cpnd_DataPagamento BETWEEN @DataInicial AND @DataFinal
       AND cpnd_Destinacao  = cpsg_Codigo
       AND cpnd_Grupo       = cpsg_Grupo
       AND cpgr_CodigoGrupo = cpsg_Grupo


SELECT * FROM #TotalGrupo

End


