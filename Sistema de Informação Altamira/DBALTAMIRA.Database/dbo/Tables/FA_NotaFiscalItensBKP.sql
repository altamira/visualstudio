CREATE TABLE [dbo].[FA_NotaFiscalItensBKP] (
    [fani_NotaFiscal]          INT        NOT NULL,
    [fani_TipoNota]            CHAR (1)   NOT NULL,
    [fani_Item]                TINYINT    NOT NULL,
    [fani_Unidade]             CHAR (2)   NULL,
    [fani_Quantidade]          REAL       NULL,
    [fani_ValorUnitario]       MONEY      NULL,
    [fani_ClassificacaoFiscal] CHAR (1)   NULL,
    [fani_CodigoTributario]    TINYINT    NULL,
    [fani_Origem]              TINYINT    NULL,
    [fani_IPI]                 TINYINT    NULL,
    [fani_Pedido]              INT        NULL,
    [fani_ItemPedido]          SMALLINT   NULL,
    [fani_Texto]               TEXT       NULL,
    [fani_Lock]                BINARY (8) NULL
);

