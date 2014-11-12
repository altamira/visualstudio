
/****** Object:  Stored Procedure dbo.SPCR_RECIBOS_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPCR_RECIBOS_ALTERAR    Script Date: 25/08/1999 20:11:56 ******/
CREATE PROCEDURE SPCR_RECIBOS_ALTERAR
	
	@Numero         int,
	@DataRecibo     smalldatetime,
	@Pedido         int,
	@BaseCalculo    money,
	@ValorRecibo    money,
    	@DataBaixaRepr  smalldatetime,
	@Observacao     varchar(50),
	@Cliente varchar(14),
	@representante varchar(3),
	@comissao money,
	@Parcela int


AS

BEGIN
	UPDATE CR_Recibos
	   SET crre_DataRecibo    = @DataRecibo,
	       crre_Pedido        = @Pedido,
	       crre_BaseCalculo   = @BaseCalculo,
	       crre_ValorRecibo   = @ValorRecibo,
                    crre_DataBaixaRepr = @DataBaixaRepr,
	       crre_Observacao    = @Observacao,
	      crre_cliente = @cliente,
	      crre_Representante = @Representante,
	      crre_Comissao = @comissao,
	      crre_Parcela = @Parcela
         WHERE crre_Numero    = @Numero
END




