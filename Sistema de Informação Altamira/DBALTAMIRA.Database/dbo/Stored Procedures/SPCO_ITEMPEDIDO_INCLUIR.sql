
/****** Object:  Stored Procedure dbo.SPCO_ITEMPEDIDO_INCLUIR    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_ITEMPEDIDO_INCLUIR    Script Date: 25/08/1999 20:11:52 ******/
CREATE PROCEDURE SPCO_ITEMPEDIDO_INCLUIR

   @Numero        int,          -- Número do pedido
   @Quantidade    float,          -- Quantidade de produtos
   @CodigoProduto char(9),      -- Codigo do produto
   @Discriminacao varchar(100), -- Discriminacao do produto
   @Unidade       char(2),      -- Unidade do produto
   @Preco         money,        -- Preco do produto
   @Ipi           char(2),      -- Ipi do produto
   @Icms          char(2),      -- Icms do produto
   @Iss           char(2),      -- Iss do servico
   @Destinacao    char(1),      -- Destinacao
   @DataEntrega   smalldatetime -- Data Entrega

AS

BEGIN

DECLARE @CodigoItem  tinyint   -- Número do item


   -- Pega o ultimo numero do item
   SELECT @CodigoItem = ISNULL(MAX(coit_Item), 0) + 1
     FROM CO_ItemPedido
    WHERE coit_Numero = @Numero

  
   
   -- Insere na tabela 
   INSERT INTO CO_ItemPedido (coit_Numero,
                              coit_Item,
                              coit_Quantidade,
                              coit_Produto,
                              coit_Discriminacao,
                              coit_Unidade,
                              coit_Preco,
                              coit_Ipi,
                              coit_Icms,
                              coit_Iss,
                              coit_Destinacao,
                              coit_DataEntrega)
                     
                      VALUES (@Numero,
                              @CodigoItem,
                              @Quantidade,
                              @CodigoProduto,
                              @Discriminacao,
                              @Unidade,
                              @Preco,
                              @Ipi,
                              @Icms,
                              @Iss,
                              @Destinacao,
                              @DataEntrega)
                              
END


