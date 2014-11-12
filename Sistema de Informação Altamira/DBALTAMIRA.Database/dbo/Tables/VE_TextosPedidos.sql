CREATE TABLE [dbo].[VE_TextosPedidos] (
    [vetx_Pedido]              INT           NOT NULL,
    [vetx_Item]                SMALLINT      NOT NULL,
    [vetx_dtPedido]            SMALLDATETIME NULL,
    [vetx_Unidade]             CHAR (2)      NOT NULL,
    [vetx_Quantidade]          REAL          NOT NULL,
    [vetx_Valor]               MONEY         NOT NULL,
    [vetx_ClassificacaoFiscal] CHAR (1)      NOT NULL,
    [vetx_CodigoTributario]    TINYINT       NOT NULL,
    [vetx_Origem]              TINYINT       NOT NULL,
    [vetx_IPI]                 REAL          NOT NULL,
    [vetx_Texto]               TEXT          NULL,
    [vetx_Peso]                INT           NULL,
    [vetx_NFiscal]             INT           NULL,
    [vetx_GBS]                 CHAR (10)     NULL,
    [vetx_Lock]                BINARY (8)    NULL,
    CONSTRAINT [PK_VE_TextosPedidos] PRIMARY KEY NONCLUSTERED ([vetx_Pedido] ASC, [vetx_Item] ASC) WITH (FILLFACTOR = 90)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[VE_TextosPedidos] TO [interclick]
    AS [dbo];

