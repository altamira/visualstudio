
/****** Object:  Stored Procedure dbo.SPFA_VENDEDORESDEFI_SELECIONA    Script Date: 23/10/2010 13:58:21 ******/
/****** Object:  Stored Procedure dbo.SPFA_VENDEDORESDEFI_SELECIONA    Script Date: 25/08/1999 20:11:56 ******/
CREATE PROCEDURE SPFA_VENDEDORESDEFI_SELECIONA

@DataInicial      smalldatetime,
@DataFinal        smalldatetime,
@Representante    char(3),
@Parametro 	 char(1)	

AS

BEGIN

   -- Cria Tabela temporária para o detalhe

   CREATE TABLE #TabVendedor( Pedido       int           null,    
                              NotaFiscal   varchar(16)          null,
                              Cliente       varchar(50)   null,
                              Parcela       smallint      null,
                              Vencimento    smalldatetime      null,
                              Pagamento     smalldatetime      null,
                              BaseCalculo   money         null,
                              Comissao      real          null,
                              ValorComissao money         null,
	                Baixado         char     null,
		   Tipo   char  null)		


   -- Insere os dados na tabela temporária
   INSERT INTO #TabVendedor ( Pedido,
                              NotaFiscal,
                              Cliente,
                              Parcela,
                              Vencimento,
                              Pagamento,
                              BaseCalculo,
                              Comissao,
                              ValorComissao,
		   Baixado, Tipo)


    SELECT  crnd_Pedido,
            crnd_NotaFiscal,
            vecl_Nome,
            crnd_Parcela,
            crnd_DataVencimento,
            crnd_DataPagamento,
            crnd_BaseCalculo,
            crnd_Comissao,
            (crnd_BaseCalculo * crnd_Comissao / 100) 'ValorComissao',
            crnd_Baixado, crnd_TipoNota

        FROM  VE_ClientesNovo,
              CR_NotasFiscaisDetalhe

           WHERE  crnd_DataBaixaRepres BETWEEN @DataInicial AND @DataFinal
             AND  ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
             AND  crnd_Representante = @Representante
             AND crnd_CNPJ = vecl_Codigo
             AND crnd_DataPagamento <= @DataFinal
           --  AND crnd_Baixado = @Parametro
            AND crnd_TipoNota='S'
       
     -- Insere os dados na tabela temporária
   INSERT INTO #TabVendedor ( Pedido,
                              NotaFiscal,
                              Cliente,
                              Parcela,
                              Vencimento,
                              Pagamento,
                              BaseCalculo,
                              Comissao,
                              ValorComissao,
		   Baixado, Tipo)


    SELECT crre_Pedido,
             'R' + LTRIM(STR(crre_Numero)),
            vecl_Nome,
            crre_Parcela,
            crre_DataRecibo,
            crre_DataBaixaRepr,
            crre_BaseCalculo,
            crre_Comissao,
            (crre_BaseCalculo * crre_Comissao / 100) 'ValorComissao',
           crre_Baixado,'S'

        FROM  VE_ClientesNovo,
              CR_Recibos

           WHERE  crre_DataBaixaRepr BETWEEN @DataInicial AND @DataFinal
             AND  crre_Representante = @Representante
             AND  crre_cliente = vecl_Codigo
             --AND crre_Baixado = @Parametro
	             
           
          SELECT * FROM #TabVendedor

             ORDER BY NotaFiscal


END







