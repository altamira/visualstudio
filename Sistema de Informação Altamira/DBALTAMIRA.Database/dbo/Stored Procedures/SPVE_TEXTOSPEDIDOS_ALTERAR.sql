
/****** Object:  Stored Procedure dbo.SPVE_TEXTOSPEDIDOS_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_TEXTOSPEDIDOS_ALTERAR    Script Date: 25/08/1999 20:11:56 ******/
CREATE PROCEDURE SPVE_TEXTOSPEDIDOS_ALTERAR
	
	@Pedido              int,
	@Item                tinyint,
             @dtPedido         smalldatetime,
	@Unidade             char(2),
    @Quantidade          real,
	@Valor               money,
    @ClassificacaoFiscal char(1),
	@CodigoTributario    tinyint,
    @Origem              tinyint,
    @IPI                 real,
    @TexPedido           text
   

AS

BEGIN

	UPDATE VE_TextosPedidos
	   SET  vetx_dtPedido            = @dtPedido,
                          vetx_Unidade             = @Unidade,
	       vetx_Quantidade          = @Quantidade,
	       vetx_Valor               = @Valor,
           vetx_ClassificacaoFiscal = @ClassificacaoFiscal,
           vetx_CodigoTributario    = @CodigoTributario,
           vetx_Origem              = @Origem,
           vetx_IPI                 = @IPI, 
           vetx_Texto               = @TexPedido
          
         WHERE vetx_Pedido = @Pedido
           AND vetx_Item = @Item

END




