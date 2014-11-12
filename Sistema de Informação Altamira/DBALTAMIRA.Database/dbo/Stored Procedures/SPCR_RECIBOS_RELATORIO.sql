
/****** Object:  Stored Procedure dbo.SPCR_RECIBOS_RELATORIO    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCR_RECIBOS_RELATORIO    Script Date: 25/08/1999 20:11:25 ******/
CREATE PROCEDURE SPCR_RECIBOS_RELATORIO

@DataInicial     smalldatetime,
@DataFinal       smalldatetime

AS

BEGIN

   Select crre_Numero,
          crre_DataRecibo,
          crre_Pedido,
          vepe_Representante,
          vecl_Nome,
          crre_ValorRecibo

      From CR_Recibos,
           VE_Clientes,
           VE_Pedidos

         Where crre_DataRecibo Between @DataInicial And @DataFinal
           And crre_Pedido = vepe_Pedido
           And vepe_Cliente = vecl_Codigo

END

   

