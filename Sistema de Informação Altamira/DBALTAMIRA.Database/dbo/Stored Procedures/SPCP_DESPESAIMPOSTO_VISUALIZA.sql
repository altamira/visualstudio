
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_VISUALIZA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_VISUALIZA    Script Date: 25/08/1999 20:11:47 ******/
CREATE PROCEDURE SPCP_DESPESAIMPOSTO_VISUALIZA

@DataInicial     smalldatetime,
@DataFinal       smalldatetime

AS

BEGIN
Create table #TabVisualiza(Sequencia  int,
                           Parcela    smallint,
                           TipoConta  char(1),
                           NumeroOP   int,
                           Descricao  char(40),
                           Vencimento smalldatetime,
                           ValorTotal money)

 Insert Into #TabVisualiza(Sequencia, 
                           Parcela,
                           TipoConta,
                           NumeroOP,
                           Descricao,
                           Vencimento,
                           ValorTotal)

 Select cpdd_Sequencia,
        cpdd_Parcela,
        cpdi_TipoConta,
        ISNULL(cpdd_NumeroOP, 0),
        cpde_Descricao,
        cpdd_DataVencimento, 
        cpdd_ValorTotal
     From CP_DespesaImpostoDetalhe, CP_DespesaImposto, CP_Descricao 
     Where cpdd_Sequencia = cpdi_Sequencia 
       And cpdi_TipoConta = cpde_Tipo 
       And cpdi_CodigoConta = cpde_Codigo 
       And cpdd_DataVencimento Between  @DataInicial And  @DataFinal
       And cpdd_DataProrrogacao Is Null
     Order By cpdd_DataVencimento 


 Insert Into #TabVisualiza(Sequencia,
                           Parcela, 
                           TipoConta,
                           NumeroOP,
                           Descricao,
                           Vencimento,
                           ValorTotal)

 Select cpdd_Sequencia,
        cpdd_Parcela,
        cpdi_TipoConta,
        ISNULL(cpdd_NumeroOP, 0),
        cpde_Descricao,
        cpdd_DataProrrogacao, 
        cpdd_ValorTotal
     From CP_DespesaImpostoDetalhe, CP_DespesaImposto, CP_Descricao 
     Where cpdd_Sequencia = cpdi_Sequencia 
       And cpdi_TipoConta = cpde_Tipo 
       And cpdi_CodigoConta = cpde_Codigo 
       And cpdd_DataProrrogacao Between  @DataInicial And  @DataFinal
     Order By cpdd_DataProrrogacao 

  Select Sequencia,
         Parcela,
         TipoConta ' ',
         NumeroOP  'OP',
         Descricao 'Descrição',
         Vencimento,
         'R$ ' + Convert(varchar, Round(ValorTotal, 2)) 'Valor Total' 
      From #TabVisualiza
      Order By Vencimento

END

