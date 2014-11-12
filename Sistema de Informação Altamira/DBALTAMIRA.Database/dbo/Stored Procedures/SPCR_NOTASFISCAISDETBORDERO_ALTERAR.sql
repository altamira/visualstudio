
/****** Object:  Stored Procedure dbo.SPCR_NOTASFISCAISDETBORDERO_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/
/****** Object:  Stored Procedure dbo.SPCR_NOTASFISCAISDET_ALTERAR    Script Date: 25/08/1999 20:11:33 ******/
CREATE PROCEDURE  SPCR_NOTASFISCAISDETBORDERO_ALTERAR 

@NotaFiscal         int,
@TipoNota           char(1),
@Parcela            smallint,
@DataVencimento     smalldatetime,
@DataPagamento      smalldatetime,
@DataProrrogacao    smalldatetime,
@ValorParcela       money,
@BaseCalculo        money,
@ValorAcrescimo     money,
@ValorDesconto      money,
@ValorTotal         money,
@TipoFaturamento    char(1),
@Banco              char(3),
@Agencia              char(10),
@Contrato             char(20),
@TipoOperacao       char(1),
@NumeroBancario     char(20),
@DiasFaturamento    numeric,
@DataBaixaRepres    smalldatetime,
@Observacao         varchar(60),
@CNPJ               char(14),
@EmissaoNF          smalldatetime,
@Representante     char(3),
@Comissao           money,
@Pedido	int,
@BaixaDoBanco  smalldatetime,
@CodInstrucao      tinyint,
@ObsInstrucao text


AS

BEGIN

	UPDATE CR_NotasFiscaisDetalhe
	      SET	 	crnd_DataVencimento  = @DataVencimento,
              		crnd_DataPagamento   = @DataPagamento,
			crnd_DataProrrogacao = @DataProrrogacao,
			crnd_ValorParcela    = @ValorParcela,
              		crnd_BaseCalculo     = @BaseCalculo,
			crnd_ValorAcrescimo  = @ValorAcrescimo,
			crnd_ValorDesconto   = @ValorDesconto,
               		crnd_ValorTotal      = @ValorTotal,
			crnd_TipoFaturamento = @TipoFaturamento,
			crnd_Banco           = @Banco,
			crnd_Agencia           = @Agencia,
			crnd_Contrato           = @Contrato,
			crnd_TipoOperacao    = @TipoOperacao,
			crnd_NumeroBancario  = @NumeroBancario,
			  crnd_DiasFaturamento = @DiasFaturamento,
			  crnd_DataBaixaRepres = @DataBaixaRepres,
			  crnd_Observacao      = @Observacao,
			  crnd_CNPJ            = @CNPJ,
			  crnd_EmissaoNF      = @EmissaoNF,
			  crnd_Representante      = @Representante,
			  crnd_Comissao     = @Comissao,
			crnd_Pedido = @Pedido,
			crnd_BaixaDoBanco = @BaixaDoBanco  ,
			crnd_CodInstrução = @CodInstrucao,      
			crnd_ObsInstrução = @ObsInstrucao
          
		  WHERE  crnd_NotaFiscal = @NotaFiscal
			 AND crnd_TipoNota = @TipoNota
			 AND crnd_Parcela = @Parcela
             			                
END







