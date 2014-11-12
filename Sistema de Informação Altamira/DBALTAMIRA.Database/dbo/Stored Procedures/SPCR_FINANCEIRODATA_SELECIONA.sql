
/****** Object:  Stored Procedure dbo.SPCR_FINANCEIRODATA_SELECIONA    Script Date: 23/10/2010 13:58:20 ******/
/****** Object:  Stored Procedure SPCR_FINANCEIRODATA_SELECIONA    Script Date: 25/08/1999 20:11:40 ******/
CREATE PROCEDURE SPCR_FINANCEIRODATA_SELECIONA

@DataInicial       smalldatetime,
@DataFinal         smalldatetime,
@Banco  	char(3)

AS

BEGIN

           SELECT Case vecl_codigo when '05004108000176' then Substring(vecl_nome,14,20) Else vecl_Nome End 'vecl_Nome',
		crnd_NotaFiscal,
		crnd_TipoNota,
		crnd_Parcela,
		crnd_Banco,
		crnd_ValorParcela,
		crnd_DataVencimento 
		FROM CR_NotasFiscaisDetalhe, VE_Clientes
		 WHERE 	vecl_Codigo = crnd_CNPJ and 
				crnd_TipoNota='M'  And
				crnd_Banco =@Banco And 
				crnd_DataVencimento between @DataInicial and @DataFinal
END








