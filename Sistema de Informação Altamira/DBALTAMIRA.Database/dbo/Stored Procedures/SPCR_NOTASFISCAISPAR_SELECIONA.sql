
/****** Object:  Stored Procedure dbo.SPCR_NOTASFISCAISPAR_SELECIONA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCR_NOTASFISCAISPAR_SELECIONA    Script Date: 25/08/1999 20:11:33 ******/
CREATE PROCEDURE SPCR_NOTASFISCAISPAR_SELECIONA

	@NotaFiscal         int,
    @TipoNota           char(1),
@Parcela int
    
AS

BEGIN

    SELECT crnd_Parcela,
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
           crnd_TipoOperacao,
           crnd_NumeroBancario,
           crnd_DiasFaturamento,
           crnd_DataBaixaRepres,
           crnd_Observacao,
           crnd_CNPJ,
           crnd_EmissaoNF,
           crnd_Representante,
           crnd_Comissao
  
      FROM CR_NotasFiscaisDetalhe
   
     WHERE crnd_NotaFiscal = @NotaFiscal
       AND crnd_TipoNota   = @TipoNota
      AND crnd_Parcela = @Parcela

    ORDER BY crnd_Parcela

END




