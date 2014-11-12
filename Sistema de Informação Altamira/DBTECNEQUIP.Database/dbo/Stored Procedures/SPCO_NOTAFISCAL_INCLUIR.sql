
/****** Object:  Stored Procedure dbo.SPCO_NOTAFISCAL_INCLUIR    Script Date: 23/10/2010 15:32:30 ******/


/****** Object:  Stored Procedure dbo.SPCO_NOTAFISCAL_INCLUIR    Script Date: 25/08/1999 20:11:22 ******/
CREATE PROCEDURE SPCO_NOTAFISCAL_INCLUIR

   @CodigoFornecedor    char(14),
   @NumeroNota          char(6),
   @TipoNota            char(1),
   @NumeroPedido        int,
   @DataEmissao         smalldatetime,
   @DataEntrada         smalldatetime,
   @ValorTotal          money,
   @NumeroParcelas      smallint
   
AS
	
BEGIN

   IF NOT EXISTS (SELECT 'X' FROM CP_NotaFiscal
                  WHERE  cpnf_Fornecedor = @CodigoFornecedor
                    AND  cpnf_NotaFiscal = @NumeroNota                    AND  cpnf_TipoNota = @TipoNota
                    AND  cpnf_Pedido = @NumeroPedido)

   BEGIN

      INSERT INTO CP_NotaFiscal( cpnf_Fornecedor,
                                 cpnf_NotaFiscal,
                                 cpnf_TipoNota,
                                 cpnf_Pedido,
                                 cpnf_DataEmissao,
                                 cpnf_DataEntrada,
                                 cpnf_ValorTotal,
                                 cpnf_Parcelas,
                                 cpnf_JaIncluso )

                  VALUES ( @CodigoFornecedor,
                           @NumeroNota,
                           @TipoNota,
                           @NumeroPedido,
                           @DataEmissao,
                           @DataEntrada,
                           @ValorTotal,
                           @NumeroParcelas,
                           'N' )

   END


END



