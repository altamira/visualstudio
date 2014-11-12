
/****** Object:  Stored Procedure dbo.SPVE_TEXTOSPEDIDOS_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_TEXTOSPEDIDOS_INCLUIR    Script Date: 25/08/1999 20:11:56 ******/
CREATE PROCEDURE SPVE_TEXTOSPEDIDOS_INCLUIR

    @Pedido              int,
	@Item                tinyint,
     @dtPedido          smalldatetime,
	@Unidade             char(2),
    @Quantidade          real,
	@Valor               money,
    @ClassificacaoFiscal char(1),
	@CodigoTributario    tinyint,
    @Origem              tinyint,
    @IPI                 real,
    @Texto               text
   

AS

BEGIN

      INSERT INTO VE_TextosPedidos(vetx_Pedido,
                                   vetx_Item,
		        vetx_dtPedido,
                                   vetx_Unidade,
	                               vetx_Quantidade,
	                               vetx_Valor,
                                   vetx_ClassificacaoFiscal,
                                   vetx_CodigoTributario,
                                   vetx_Origem,
                                   vetx_IPI, 
                                   vetx_Texto)     
	                                             
		                   VALUES (@Pedido,
                                   @Item,
		        @dtPedido,
                                   @Unidade,
	                               @Quantidade,
	                               @Valor,
                                   @ClassificacaoFiscal,
                                   @CodigoTributario,
                                   @Origem,
                                   @IPI, 
                                   @Texto)

END




