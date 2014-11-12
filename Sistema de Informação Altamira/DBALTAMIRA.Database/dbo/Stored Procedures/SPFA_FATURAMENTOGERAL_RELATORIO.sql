
/****** Object:  Stored Procedure dbo.SPFA_FATURAMENTOGERAL_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/

/****** Object:  Stored Procedure dbo.SPFA_FATURAMENTOGERAL_RELATORIO    Script Date: 20/02/2008 20:11:25 ******/
CREATE PROCEDURE SPFA_FATURAMENTOGERAL_RELATORIO

@DataInicial      smalldatetime,
@DataFinal        smalldatetime

AS

Begin
 
   Select fanf_DataNota,
          fanf_NotaFiscal,
          vecl_Nome,
          fanf_TipoNota,
          fanf_CFOP,
          fanf_ValorTotal

     From FA_NotaFiscal ,  VE_ClientesNovo, FA_cfop

       Where fanf_DataNota Between @DataInicial And @DataFinal
         And fanf_ClienteFornecedor = 'C'
         and fanf_CNPJ = vecl_Codigo
         and facf_Codigo = substring(fanf_CFOP,1,3)
         and facf_Completa = substring(fanf_CFOP,5,1)
         and fanf_TipoNota = 'S'
       order by fanf_NotaFiscal
End



















