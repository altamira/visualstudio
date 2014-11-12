
/****** Object:  Stored Procedure dbo.SPCP_PAGAMDIARIOFOR_CONSULTA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_PAGAMDIARIOFOR_CONSULTA    Script Date: 25/08/1999 20:11:55 ******/
CREATE PROCEDURE SPCP_PAGAMDIARIOFOR_CONSULTA

@Data      smalldatetime

AS

BEGIN

    SELECT  cofc_Nome,
            cpnd_NotaFiscal,
            cpnd_Parcela,
            cpnd_ValorTotal

        FROM  CP_NotaFiscalDetalhe,
              CO_Fornecedor

           WHERE  cpnd_DataPagamento = @Data
             AND  cpnd_Fornecedor = cofc_Codigo
             
END    

