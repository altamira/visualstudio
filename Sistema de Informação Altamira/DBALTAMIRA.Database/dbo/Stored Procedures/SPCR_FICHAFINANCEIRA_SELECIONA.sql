
/****** Object:  Stored Procedure dbo.SPCR_FICHAFINANCEIRA_SELECIONA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCR_FICHAFINANCEIRA_SELECIONA    Script Date: 25/08/1999 20:11:41 ******/
CREATE PROCEDURE SPCR_FICHAFINANCEIRA_SELECIONA

@Cliente      char(14)

AS

BEGIN

    SELECT crnd_EmissaoNF,
           crnd_Pedido,
           crnd_NotaFiscal,
           crnd_TipoNota,
           crnd_Parcela,
           crnd_ValorTotal,
           crnd_DataVencimento,
           data = case datalength(crnd_DataProrrogacao) when  4 then crnd_DataProrrogacao else crnd_DataVencimento end, 
           crnd_DataProrrogacao,
           crnd_DataPagamento,
           crnd_Banco
           

        FROM  CR_NotasFiscaisDetalhe

           WHERE crnd_CNPJ          = @Cliente
            ORDER BY crnd_CNPJ,crnd_NotaFiscal,crnd_Parcela
END







