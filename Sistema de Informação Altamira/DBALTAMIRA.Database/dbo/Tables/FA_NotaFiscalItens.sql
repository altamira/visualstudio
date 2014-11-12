CREATE TABLE [dbo].[FA_NotaFiscalItens] (
    [fani_NotaFiscal]          INT           NOT NULL,
    [fani_TipoNota]            NVARCHAR (1)  NOT NULL,
    [fani_Item]                TINYINT       NOT NULL,
    [fani_Unidade]             NVARCHAR (2)  NULL,
    [fani_Quantidade]          REAL          NULL,
    [fani_ValorUnitario]       MONEY         NULL,
    [fani_ClassificacaoFiscal] NVARCHAR (1)  NULL,
    [fani_CodigoTributario]    TINYINT       NULL,
    [fani_Origem]              TINYINT       NULL,
    [fani_IPI]                 TINYINT       NULL,
    [fani_Pedido]              INT           NULL,
    [fani_ItemPedido]          SMALLINT      NULL,
    [fani_Texto]               TEXT          NULL,
    [fani_Lock]                VARBINARY (8) NULL
);

