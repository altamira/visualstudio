
/****** Object:  Stored Procedure dbo.SPFA_NOTASCLD_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/

/****** Object:  Stored Procedure dbo.SPFA_NOTASCLD_RELATORIO    Script Date: 25/08/1999 20:11:25 ******/
CREATE PROCEDURE SPFA_NOTASCLD_RELATORIO

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
         AND FANF_CANCELADA = 'S'
         and fanf_CNPJ = vecl_Codigo
         and facf_Codigo = substring(fanf_CFOP,1,3)
         and facf_Completa = substring(fanf_CFOP,5,1)
       order by fanf_NotaFiscal
End


