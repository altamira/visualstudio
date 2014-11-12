
/****** Object:  Stored Procedure dbo.SPCR_DUPLICATAGERAL_SELECIONA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCR_DUPLICATAGERAL_SELECIONA    Script Date: 25/08/1999 20:11:40 ******/
CREATE PROCEDURE SPCR_DUPLICATAGERAL_SELECIONA

@DataInicial       smalldatetime,
@DataFinal         smalldatetime

AS

DECLARE  @Pendente    money

BEGIN
        
   Select @Pendente = ISNULL(sum(crnd_ValorTotal), 0) 
    From CR_NotasFiscaisDetalhe,
         FA_NotaFiscal
    Where fanf_DataNota BETWEEN @DataInicial AND @DataFinal 
      AND crnd_DataPagamento Is Null     
      AND fanf_NotaFiscal = crnd_NotaFiscal
      AND fanf_TipoNota   = crnd_TipoNota 
              
              
         SELECT  fanf_NotaFiscal,
                 fanf_TipoNota,
                 fanf_DataNota,
                 crnd_Parcela,
                 crnd_ValorTotal,
                 fanf_CNPJ,  
                 vecl_Nome,
                 crnd_TipoOperacao,
                 fnba_NomeBanco,
                 crnd_DataVencimento,
                 crnd_DataProrrogacao,
                 crnd_DataPagamento,
                 crnd_Observacao,
                 @Pendente 'Pendente'
                 
              
              FROM FA_NotaFiscal,
                   CR_NotasFiscaisDetalhe,
                   FN_Bancos,
                   VE_Clientes
             
             WHERE fanf_DataNota BETWEEN @DataInicial AND @DataFinal
               AND fanf_NotaFiscal = crnd_NotaFiscal
               AND fanf_TipoNota   = crnd_TipoNota
               AND crnd_Banco      = fnba_Codigo
               AND fanf_CNPJ       = vecl_Codigo
	 Order by fanf_NotaFiscal,fanf_TipoNota

      
END

           
             


