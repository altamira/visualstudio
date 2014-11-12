
/****** Object:  Stored Procedure dbo.SPCR_FICHAFINANCANTI_SELECIONA    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPCR_FICHAFINANCANTI_SELECIONA    Script Date: 25/08/1999 20:11:33 ******/
CREATE PROCEDURE SPCR_FICHAFINANCANTI_SELECIONA

@Cliente      char(14)

AS

BEGIN

    SELECT crmo_Emissao,
           crmo_NotaFiscal,
           crmo_TipoNota,
           crmo_Parcela,
           crmo_Valor,
           crmo_Vencimento,
           crmo_Pagamento,
           crmo_banco
           

        FROM CR_Movimento

           WHERE crmo_Codigo = @Cliente
                          
               ORDER BY crmo_Emissao


END


