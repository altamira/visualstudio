
/****** Object:  Stored Procedure dbo.SPCP_OPDESPIMPOSTO_RELATORIO    Script Date: 23/10/2010 13:58:21 ******/
/****** Object:  Stored Procedure dbo.SPCP_OPDESPIMPOSTO_RELATORIO    Script Date: 25/08/1999 20:11:48 ******/
CREATE PROCEDURE SPCP_OPDESPIMPOSTO_RELATORIO

    @Sequencia   Int

AS

BEGIN

     -- Seleciona a ordem de pagamento da parcela 
     SELECT cpdd_DataOP,
            cpdd_NumeroOP,
            cpde_Descricao,
            cpdi_DataEmissao,
            cpdi_ValorTotal,
            cpdi_Parcelas,
            cpdd_Parcela,
            cpdi_Periodo,
            cpdd_DataVencimento,
            cpdd_DataProrrogacao,
            cpdd_ValorTotal,
            cpdd_Observacao,
            cpdd_Valor,
            cpdd_ValorAcrescimo,
            cpdd_ValorDesconto,
            cpdd_ValorTotal,
            cpdi_TipoConta
       
       FROM CP_DespesaImpostoDetalhe,
            CP_DespesaImposto,
            CP_Descricao
      WHERE cpdd_Sequencia = @Sequencia
        AND cpdi_Sequencia = cpdd_Sequencia
        AND cpde_Codigo    = cpdi_CodigoConta
        AND cpde_Tipo      = cpdi_TipoConta
        ORDER BY  cpdd_Parcela
END

