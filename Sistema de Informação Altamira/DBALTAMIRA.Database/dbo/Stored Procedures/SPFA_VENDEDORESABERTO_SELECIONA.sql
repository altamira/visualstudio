
/****** Object:  Stored Procedure dbo.SPFA_VENDEDORESABERTO_SELECIONA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPFA_VENDEDORESABERTO_SELECIONA    Script Date: 25/08/1999 20:11:56 ******/
CREATE PROCEDURE SPFA_VENDEDORESABERTO_SELECIONA

@DataInicial      smalldatetime,
@DataFinal        smalldatetime,
@Parametro 	    char(1)	

AS

BEGIN

   -- Cria Tabela temporária para o detalhe

   CREATE TABLE #TabVendedor( Pedido        int          null,    
                              NotaFiscal    varchar(16)           null,
                              Cliente       varchar(50)   null,
                              Parcela       smallint      null,
                              Vencimento    smalldatetime      null,
                              Pagamento     smalldatetime      null,
                              BaseCalculo   money         null,
                              Comissao      real          null,
                              ValorComissao money         null, 
		    Baixado	 char 	      null,
		    Tipo		char	null)

   -- Insere os dados (por Vencimento)
   INSERT INTO #TabVendedor ( Pedido,
                              NotaFiscal,
                              Cliente,
                              Parcela,
                              Vencimento,
                              Pagamento,
                              BaseCalculo,
                              Comissao,
                              ValorComissao,
 		   Baixado,
		   Tipo )

    SELECT  crnd_Pedido,
            crnd_NotaFiscal,
            vecl_Nome,
            crnd_Parcela,
            crnd_DataVencimento,
            crnd_DataPagamento,
            crnd_BaseCalculo,
            crnd_Comissao,
            (crnd_BaseCalculo * crnd_Comissao / 100) 'ValorComissao',
            crnd_Baixado 	,
	crnd_TipoNota

        FROM  VE_ClientesNovo,
              CR_NotasFiscaisDetalhe

           WHERE  crnd_DataVencimento BETWEEN @DataInicial AND @DataFinal
             AND crnd_DataPagamento IS NULL
             AND crnd_DataBaixaRepres IS NULL
             AND crnd_DataProrrogacao IS NULL
             AND  ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
             AND  crnd_CNPJ = vecl_Codigo
            AND crnd_TipoNota='S'
--             AND crnd_Baixado = @Parametro        
                          
    -- Insere os dados (por Prorrogacao)
   INSERT INTO #TabVendedor ( Pedido,
                              NotaFiscal,
                              Cliente,
                              Parcela,
                              Vencimento,
                              Pagamento,
                              BaseCalculo,
                              Comissao,
                              ValorComissao, 
		    Baixado,
		    Tipo)

    SELECT  crnd_Pedido,
            crnd_NotaFiscal,
            vecl_Nome,
            crnd_Parcela,
            crnd_DataProrrogacao,
            crnd_DataPagamento,
            crnd_BaseCalculo,
            crnd_Comissao,
            (crnd_BaseCalculo * crnd_Comissao / 100) 'ValorComissao',
            crnd_Baixado   	 ,
	crnd_TipoNota

        FROM  VE_ClientesNovo,
              CR_NotasFiscaisDetalhe

           WHERE crnd_DataProrrogacao BETWEEN @DataInicial AND @DataFinal
             AND crnd_DataPagamento IS NULL
             AND crnd_DataBaixaRepres IS NULL
             AND  ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
             AND  crnd_CNPJ = vecl_Codigo   
            AND crnd_TipoNota='S'
--            AND crnd_Baixado = @Parametro	



    --  RECIBOS
    -- Insere os dados (ja vencido Prorrogacao)
   INSERT INTO #TabVendedor ( Pedido,
                              NotaFiscal,
                              Cliente,
                              Parcela,
                              Vencimento,
                              Pagamento,
                              BaseCalculo,
                              Comissao,
                              ValorComissao, 
		   Baixado,
		   Tipo)

    SELECT crre_Pedido,
             'R' + LTRIM(STR(crre_Numero)),
            vecl_Nome,
            crre_Parcela,
            crre_DataRecibo,
            crre_DataBaixaRepr,
            crre_BaseCalculo,
            crre_Comissao,
            (crre_BaseCalculo * crre_Comissao / 100) 'ValorComissao',
            crre_Baixado,
	'S'
        FROM  VE_ClientesNovo,
              CR_Recibos
             WHERE  crre_DataRecibo BETWEEN @DataInicial AND @DataFinal
 	and crre_DataBaixaRepr is null
             AND  crre_Cliente = vecl_Codigo
--	AND crre_Baixado = @Parametro       

	order by crre_Numero,crre_Pedido      

     SELECT * FROM #TabVendedor

             ORDER BY NotaFiscal
END







