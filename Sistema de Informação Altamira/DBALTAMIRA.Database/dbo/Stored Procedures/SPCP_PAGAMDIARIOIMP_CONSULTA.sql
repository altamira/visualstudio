
/****** Object:  Stored Procedure dbo.SPCP_PAGAMDIARIOIMP_CONSULTA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_PAGAMDIARIOIMP_CONSULTA    Script Date: 25/08/1999 20:11:49 ******/
CREATE PROCEDURE SPCP_PAGAMDIARIOIMP_CONSULTA

@Data      smalldatetime

AS

BEGIN

    SELECT  cpde_Descricao,
            cpdd_Parcela,
            cpdd_ValorTotal,
            cpdi_Periodo

        FROM  CP_DespesaImposto,
              CP_DespesaImpostoDetalhe,
              CP_Descricao

           WHERE  cpdi_TipoConta = 'I'
             AND  cpdi_Sequencia = cpdd_Sequencia
             AND  cpdd_DataPagamento = @Data
             AND  cpdi_TipoConta = cpde_Tipo
             AND  cpdi_CodigoConta = cpde_Codigo
             
END    

