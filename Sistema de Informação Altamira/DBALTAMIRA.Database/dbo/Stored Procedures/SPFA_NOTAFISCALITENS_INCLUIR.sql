
/****** Object:  Stored Procedure dbo.SPFA_NOTAFISCALITENS_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFA_NOTAFISCALITENS_INCLUIR    Script Date: 25/08/1999 20:11:50 ******/
CREATE PROCEDURE SPFA_NOTAFISCALITENS_INCLUIR

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
    @ItemPedido int,
    @Textos text
   
   
AS
	
BEGIN

   INSERT INTO FA_NotaFiscalItens( fani_NotaFiscal,
                                   fani_TipoNota,
                                   fani_Item,
                                   fani_Unidade,
                                   fani_Quantidade,
                                   fani_ValorUnitario,
                                   fani_ClassificacaoFiscal,
                                   fani_CodigoTributario,
                                   fani_Origem,
                                   fani_IPI ,
		fani_Pedido,
		fani_ItemPedido,
		fani_Texto)

                          VALUES ( @NotaFiscal,
                                   @TipoNota,
                                   @Item,
                                   @Unidade,
                                   @Quantidade,
                                   @ValorUnitario,
                                   @ClassifFiscal,
                                   @CodTributario,
                                   @Origem,
                                   @IPI ,
		@Pedido,
		@ItemPedido,
		@TExtos)

END



