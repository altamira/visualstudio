
/****** Object:  Stored Procedure dbo.SPFA_NOTAFISCALITENS_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPFA_NOTAFISCALITENS_ALTERAR    Script Date: 25/08/1999 20:11:50 ******/
CREATE PROCEDURE SPFA_NOTAFISCALITENS_ALTERAR
	
   @NotaFiscal          int,
   @TipoNota            char(1),
   @Item                tinyint,
   @Unidade             char(2),
   @Quantidade          real,
   @ValorUnitario       money,
   @ClassifFiscal       char(1),
   @CodTributario       tinyint,
   @Origem              tinyint,
   @IPI                 tinyint,
   @Pedido int,
    @ItemPedido int

AS


BEGIN


	UPDATE FA_NotaFiscalItens
	   SET fani_Unidade             = @Unidade,
           fani_Quantidade          = @Quantidade,
           fani_ValorUnitario       = @ValorUnitario,
           fani_ClassificacaoFiscal = @ClassifFiscal,
           fani_CodigoTributario    = @CodTributario,
           fani_Origem              = @Origem,
           fani_IPI                 = @IPI,
	fani_Pedido = @Pedido,
	fani_ItemPedido = @ItemPedido
           
        
         WHERE fani_NotaFiscal = @NotaFiscal
           AND fani_TipoNota = @TipoNota
           AND fani_Item = @Item

END




   



