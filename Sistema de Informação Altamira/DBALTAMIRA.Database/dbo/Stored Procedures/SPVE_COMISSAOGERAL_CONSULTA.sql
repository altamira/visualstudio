
/****** Object:  Stored Procedure dbo.SPVE_COMISSAOGERAL_CONSULTA    Script Date: 23/10/2010 13:58:22 ******/
/****** Object:  Stored Procedure dbo.SPVE_COMISSAOGERAL_CONSULTA    Script Date: 25/08/1999 20:11:36 ******/
CREATE PROCEDURE SPVE_COMISSAOGERAL_CONSULTA

@DataInicial    smalldatetime,
@DataFinal      smalldatetime

AS

BEGIN

SELECT vepe_Representante, 
       verp_RazaoSocial, 
       ISNULL(SUM(vepe_ValorVenda), 0) ValorVenda,
       SUM(ISNULL((vepe_ValorVenda), 0) * ISNULL((vepe_Comissao), 0) / 100) ValorComissao

  FROM VE_Pedidos,
       VE_Representantes

 WHERE vepe_DataPedido Between @DataInicial AND @DataFinal
   AND vepe_Representante = verp_Codigo

GROUP BY vepe_Representante, verp_RazaoSocial

ORDER BY vepe_Representante


END







