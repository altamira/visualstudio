
/****** Object:  Stored Procedure dbo.SPCR_NOTASFISCAISDET_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/
/****** Object:  Stored Procedure dbo.SPCR_NOTASFISCAISDET_INCLUIR    Script Date: 25/08/1999 20:11:33 ******/
CREATE PROCEDURE  SPCR_NOTASFISCAISDET_INCLUIR

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
@ObsInstrucao       text

AS

BEGIN

  INSERT INTO CR_NotasFiscaisDetalhe (crnd_NotaFiscal,
					crnd_TipoNota,
                                      			crnd_Parcela,
					crnd_DataVencimento,
                                      			crnd_DataPagamento,
					crnd_DataProrrogacao,
					crnd_ValorParcela,
                                      			crnd_BaseCalculo,
					crnd_ValorAcrescimo,
					crnd_ValorDesconto,
                                      			crnd_ValorTotal,
					crnd_TipoFaturamento,
					crnd_Banco,
					crnd_Agencia,
					crnd_Contrato,
					crnd_TipoOperacao,
					crnd_NumeroBancario,
					crnd_DiasFaturamento,
					crnd_DataBaixaRepres,
					crnd_Observacao,
					crnd_CNPJ,
					crnd_EmissaoNF,
					crnd_Representante,
					crnd_Comissao,
					crnd_Pedido,
					crnd_BaixaDoBanco,
					crnd_CodInstrução,      
					crnd_ObsInstrução,
					crnd_Baixado)

                            VALUES (@NotaFiscal,
                                    @TipoNota,
                                    @Parcela,
                                    @DataVencimento,
                                    @DataPagamento,
                                    @DataProrrogacao,
                                    @ValorParcela,
                                    @BaseCalculo,
                                    @ValorAcrescimo,
                                    @ValorDesconto,
                                    @ValorTotal,
                                    @TipoFaturamento,
                                    @Banco,
                                    @Agencia,
                                    @Contrato,
                                    @TipoOperacao,
                                    @NumeroBancario,
                                    @DiasFaturamento,
                                    @DataBaixaRepres,
                                    @Observacao,
		    @CNPJ,
		    @EmissaoNF,      
		    @Representante,
    		    @Comissao,
		    @Pedido,
		    @BaixaDoBanco,
		    @CodInstrucao, 
		    @ObsInstrucao,
		    'N')

END










