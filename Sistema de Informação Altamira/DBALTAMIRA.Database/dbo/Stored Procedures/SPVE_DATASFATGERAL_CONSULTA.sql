
/****** Object:  Stored Procedure dbo.SPVE_DATASFATGERAL_CONSULTA    Script Date: 23/10/2010 13:58:22 ******/
/****** Object:  Stored Procedure dbo.SPVE_DATASFATGERAL_CONSULTA    Script Date: 25/08/1999 20:11:28 ******/
CREATE PROCEDURE SPVE_DATASFATGERAL_CONSULTA

@Cliente as Char(14)
AS

BEGIN
  Select vepe_DataPedido,
         vepe_Pedido,
         vecl_Nome,
         vepe_Porcentagem1,
         vepe_Porcentagem2,
         vepe_Porcentagem3,
         vepe_Porcentagem4,
         vepe_Porcentagem5,
         vepe_Porcentagem6,
         vepe_Porcentagem7,
         vepe_Porcentagem8,
         vepe_Dias1,
         vepe_Dias2,
         vepe_Dias3,
         vepe_Dias4,
         vepe_Dias5,
         vepe_Dias6,
         vepe_Dias7,
         vepe_Dias8,
         vepe_Escolha1,
         vepe_Escolha2,  
         vepe_Escolha3,
         vepe_Escolha4, 
         vepe_Escolha5,
         vepe_Escolha6,  
         vepe_Escolha7,
         vepe_Escolha8, 
         vepe_Valor1,
         vepe_Valor2,
         vepe_Valor3,
         vepe_Valor4,
         vepe_Valor5,
         vepe_Valor6,
         vepe_Valor7,
         vepe_Valor8,
         vepe_Tipo1,
         vepe_Tipo2,
         vepe_Tipo3,
         vepe_Tipo4,
         vepe_Tipo5,
         vepe_Tipo6,
         vepe_Tipo7,
         vepe_Tipo8
      From VE_Pedidos,           VE_ClientesNovo

        Where vepe_Cliente = @Cliente
          And vepe_Cliente = vecl_Codigo

          Order by vepe_NotaFiscal
END
