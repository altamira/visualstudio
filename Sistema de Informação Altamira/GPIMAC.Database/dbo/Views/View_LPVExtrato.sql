




CREATE VIEW [dbo].[View_LPVExtrato]
AS
SELECT     
	PedidoEmpresa				VwExtratoLpEmp, 
	PedidoNumero				VwExtratoLpPed,
	Id							VwExtratoLpSeq, 
	PedidoDtEmissao				VwExtratoLpEnt, 
	PedidoDtEntrega				VwExtratoLpSai, 
	Origem						VwExtratoLpOri,
	Empresa						VwExtratoLpOriEmp, 
	NumeroDaOrigem				VwExtratoLpOriNum, 
	TipoOperacao				VwExtratoLpDebCred, 
	ValorDaOrigemProdutos		VwExtratoLpProTot, 
	ValorDaOrigemIpi			VwExtratoLpIpiTot, 
	ValorDaOrigemTotal			VwExtratoLpTotPed, 
    SaldoParcialPedido			VwExtratoLpPedSalPar, 
    PorComissao					VwExtratoLpComPor, 
    ValorComissao				VwExtratoLpComVal, 
    SaldoParcialComissao		VwExtratoLpComSalPar,
    TituloLiquidado				VwExtratoLpTitLiq,
	TotalLiquidado				VwExtratoLpTitLiqTot,
	SaldoParcialPedidoLiquidado VwExtratoLpTitLiqSalPar
FROM  dbo.GPFN_RetornarExtratoDeTodosOsPedidosDeVenda() AS LPVExtrato






GO
GRANT SELECT
    ON OBJECT::[dbo].[View_LPVExtrato] TO [interclick]
    AS [dbo];

