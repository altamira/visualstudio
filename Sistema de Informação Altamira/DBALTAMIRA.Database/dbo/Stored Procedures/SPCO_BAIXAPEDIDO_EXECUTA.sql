
/****** Object:  Stored Procedure dbo.SPCO_BAIXAPEDIDO_EXECUTA    Script Date: 23/10/2010 13:58:22 ******/

/****** Object:  Stored Procedure dbo.SPCO_BAIXAPEDIDO_EXECUTA    Script Date: 25/08/1999 20:11:57 ******/
CREATE PROCEDURE SPCO_BAIXAPEDIDO_EXECUTA 
 
 @NumeroPedido     int,            -- Número do pedido
 @CodigoProduto    char(9),        -- Codigo do produto do item
 @NumeroItem       int,        -- Numero do item do pedido
 @Quantidade       float,          -- Quantidade que foi baixada
 @Valor             money,          -- Valor da nota fiscal
 @NumeroNota       char(6),        -- Numero da nota fiscal
 @DataNota         smalldatetime,  -- Data da nota fiscal
 @DataEntrada      smalldatetime,  -- Data da entrada do produto
 @Credito           char(30),       -- Tipo de credito ipi/icms
 @TipoBaixa         char(1),        -- Pode ser T para total e P para parcial
    @ValorTotal        money,          -- Valor Total da Nota Fiscal
 @Parcelas          smallint,        -- Numero de parcelas
 @TipoMP  char(3),   -- Tipo de Matéria Prima
 @DataDaBaixa  smalldatetime,
@CFOP char(10),
@ICMS float,
@IPI float,
@TotalProdutos money

 
AS
 
DECLARE @CodigoCredito     char(1), 
        @CodigoFornecedor  char(14),
        @TipoPedido        char(1)
 
BEGIN
 
   SELECT @CodigoFornecedor = cope_Fornecedor, 
          @TipoPedido = cope_TipoPedido
           FROM CO_Pedido
            WHERE cope_Numero = @NumeroPedido
   
   SELECT @CodigoCredito = codc_Codigo
     FROM CO_DescricaoCredito
    WHERE codc_descricao = @Credito
 
 
 
   -- Inclui na nota   
   INSERT INTO CO_ItemNota (coin_Numero,
                            coin_Item,
                            coin_TipoPedido,
                            coin_Quantidade,
                            coin_Valor,
                            coin_Nota,
                            coin_DataNota,
                            coin_DataEntrada,
                            coin_Credito,
		coin_CFOP,
		coin_AliqICMS,
		coin_AliqIPI,
		coin_ValorProdutos)
 
                    SELECT @NumeroPedido,
                           @NumeroItem,
                           cope_TipoPedido,
                           @Quantidade,
                           @Valor,
                           @NumeroNota,
                           @DataNota,
                           @DataEntrada,
                           @CodigoCredito,
		@CFOP,
		@ICMS,
		@IPI,
		@TotalProdutos
 
                           FROM CO_Pedido
                           WHERE cope_Numero = @NumeroPedido
   
   IF SUBSTRING(@CodigoProduto, 4, 6) <> '000000' 
 
   BEGIN
      -- Atualiza o preco do produto na tabela almoxarifado
   
      UPDATE CO_Almoxarifado
         SET coal_Valor = @Valor,
             coal_Saldo = coal_Saldo + @Quantidade
      WHERE coal_Codigo = @CodigoProduto 
 
      IF SUBSTRING(@CodigoProduto, 1, 3) = 'WBO'
 
      BEGIN
      
      -- insere na tabela de historico de bobinas
 
         INSERT INTO CO_HistoricoBobina(cohb_Codigo,
                                        cohb_Movimento,
                                        cohb_Nota,
                                        cohb_Pedido,
                                        cohb_Data,
                                        cohb_Quantidade)
 
                            VALUES (@CodigoProduto,
                                    'E',   -- Entrada
                                    @NumeroNota,
                                    @NumeroPedido,
                                    @DataEntrada,
                                    @Quantidade)
 
      END
 
      IF SUBSTRING(@CodigoProduto, 1, 3) = 'WCB'
 
      BEGIN
      
      -- insere na tabela de historico de Chapas
         INSERT INTO CO_HistoricoChapa(cohc_Codigo,
                                        cohc_Movimento,
                                        cohc_Nota,
                                        cohc_Pedido,
                                        cohc_Data,
                                        cohc_Quantidade)
 
                            VALUES (@CodigoProduto,
                                    'E',   -- Entrada
                                    @NumeroNota,
                                    @NumeroPedido,
                                    @DataEntrada,
                                    @Quantidade)
 
      END
 

   END
 

   IF @TipoBaixa = 'T' 
 
      BEGIN
 
         UPDATE CO_Pedido 
            SET  cope_Status = 'T',
  cope_DataDaBaixa =@DataDaBaixa,
  cope_TipoMP = @TipoMP
          WHERE cope_Numero = @NumeroPedido
 

      END
 
   ELSE
 

      BEGIN
 
         UPDATE CO_Pedido 
            SET  cope_Status = 'P',
  cope_DataDaBaixa =@DataDaBaixa,
  cope_TipoMP = @TipoMP
          WHERE cope_Numero = @NumeroPedido
 
      END
 
IF @TipoPedido = 'P'
 
    BEGIN
 
        EXEC SPCO_NOTAFISCAL_INCLUIR @CodigoFornecedor,
                                     @NumeroNota,
                                     @TipoPedido,
                                     @NumeroPedido,
                                     @DataNota,
                                     @DataEntrada,
                                     @ValorTotal,
                                     @Parcelas
END
 
END

