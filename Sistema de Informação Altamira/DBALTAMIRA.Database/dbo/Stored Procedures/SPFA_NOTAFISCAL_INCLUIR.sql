
/****** Object:  Stored Procedure dbo.SPFA_NOTAFISCAL_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPFA_NOTAFISCAL_INCLUIR    Script Date: 25/08/1999 20:11:41 ******/
CREATE PROCEDURE SPFA_NOTAFISCAL_INCLUIR

   @NotaFiscal          int,
   @TipoNota            char(1),
   @DataNota            smalldatetime,
   @Pedido              int,
   @CNPJ                char(14),
   @Inscricao           char(14),
   @ClienteFornecedor   char(1),
   @Estado              char(2),
   @CFOP                char(6),
   @DescricaoCFOP varchar(40),
   @ICMS                char(2),
   @ValorTotal          money,
   @BaseCalculoICMS     money,
   @ValorIPI            money,
   @ValorIPIOutros      money,
   @ValorICMS           money,
   @ValorICMSOutros     money,
   @Situacao1           int,
   @Situacao2           int,
   @Representante       char(3),
   @Comissao               real,
   @QtdePagto             tinyint,
   @Vencimento1         smalldatetime,
   @Vencimento2         smalldatetime,
   @Vencimento3         smalldatetime,
   @Vencimento4         smalldatetime,
   @Vencimento5         smalldatetime,
   @Vencimento6         smalldatetime,
   @Vencimento7         smalldatetime,
   @Vencimento8         smalldatetime,
   @Pagamento1          money,
   @Pagamento2          money, 
   @Pagamento3          money,
   @Pagamento4          money, 
   @Pagamento5          money,
   @Pagamento6          money, 
   @Pagamento7          money,
   @Pagamento8          money,
   @NfVinculada           int
   
AS
	
BEGIN

   INSERT INTO FA_NotaFiscal( fanf_NotaFiscal,
                              fanf_TipoNota,
                              fanf_DataNota,
                              fanf_Pedido,
                              fanf_CNPJ,
                              fanf_Inscricao,
                              fanf_ClienteFornecedor,
                              fanf_Estado,
                              fanf_CFOP,
		   fanf_DescricaoCFOP,
                              fanf_ICMS,
                              fanf_ValorTotal,
                              fanf_BaseCalculoICMS,
                              fanf_ValorIPI,
                              fanf_ValorIPIOutros,
                              fanf_ValorICMS,
                              fanf_ValorICMSOutros,
                              fanf_Situacao1,
                              fanf_Situacao2,
                              fanf_Representante,
                              fanf_Comissao,
                              fanf_QtdePagto,
                              fanf_Vencimento1,
                              fanf_Vencimento2,
                              fanf_Vencimento3,
                              fanf_Vencimento4, 
                              fanf_Vencimento5,
                              fanf_Vencimento6,
                              fanf_Vencimento7,
                              fanf_Vencimento8, 
                              fanf_Pagamento1,
                              fanf_Pagamento2,
                              fanf_Pagamento3,
                              fanf_Pagamento4,
                              fanf_Pagamento5,
                              fanf_Pagamento6,
                              fanf_Pagamento7,
                              fanf_Pagamento8,
                              fanf_NfVinculada,
                              fanf_Cancelada,
                              fanf_JaIncluso,
		   fanf_JaImpresso )

                  VALUES ( @NotaFiscal,
                           @TipoNota,
                           @DataNota,
                           @Pedido,
                           @CNPJ,
                           @Inscricao,
                           @ClienteFornecedor,
                           @Estado,
                           @CFOP,
		@DescricaoCFOP,
                           @ICMS,
                           @ValorTotal,
                           @BaseCalculoICMS,
                           @ValorIPI,
                           @ValorIPIOutros,
                           @ValorICMS,
                           @ValorICMSOutros,                           @Situacao1,                           @Situacao2,
                           @Representante,
                           @Comissao,
                           @QtdePagto,
                           @Vencimento1,
                           @Vencimento2,
                           @Vencimento3,
                           @Vencimento4,
                           @Vencimento5,
                           @Vencimento6,
                           @Vencimento7,
                           @Vencimento8,
                           @Pagamento1,
                           @Pagamento2, 
                           @Pagamento3,
                           @Pagamento4, 
                           @Pagamento5,
                           @Pagamento6, 
                           @Pagamento7,
                           @Pagamento8,
                           @NfVinculada,
                           'N',
                           'N',
		'N' )

END

















