
/****** Object:  Stored Procedure dbo.SPCR_RECIBOS_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPCR_RECIBOS_INCLUIR    Script Date: 25/08/1999 20:11:56 ******/
CREATE PROCEDURE SPCR_RECIBOS_INCLUIR

	@Numero         int,
	@DataRecibo     smalldatetime,
	@Pedido         int,
	@BaseCalculo    money,
	@ValorRecibo    money,
	@DataBaixaRepr  smalldatetime,
	@Cliente	varchar(14),
	@Representante	varchar(3),
	@Comissao		money,
	@Observacao     varchar(50),
	@Parcela int

AS

BEGIN

	INSERT INTO CR_Recibos (crre_Numero,
			                crre_DataRecibo,
				            crre_Pedido,
				            crre_BaseCalculo,
				            crre_ValorRecibo,
                                                                    crre_DataBaixaRepr,
                                                                    crre_Cliente,
                                                                    crre_Representante,
                                                                    crre_Comissao,
				            crre_Observacao, 
				crre_Baixado,	
				crre_Parcela)
		      VALUES (@Numero,
			          @DataRecibo,
			          @Pedido,
			          @BaseCalculo,
			          @ValorRecibo,	
                      		         @DataBaixaRepr,
				@Cliente,
				@Representante,
				@Comissao,
			          @Observacao,
 				'N',
				@Parcela)

END





