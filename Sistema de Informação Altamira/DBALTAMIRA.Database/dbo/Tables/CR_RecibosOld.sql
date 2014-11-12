CREATE TABLE [dbo].[CR_RecibosOld] (
    [crre_Numero]        INT           NOT NULL,
    [crre_DataRecibo]    SMALLDATETIME NOT NULL,
    [crre_Pedido]        INT           NOT NULL,
    [crre_BaseCalculo]   MONEY         NOT NULL,
    [crre_ValorRecibo]   MONEY         NOT NULL,
    [crre_DataBaixaRepr] SMALLDATETIME NULL,
    [crre_Observacao]    VARCHAR (30)  NULL,
    [crre_Comissao]      MONEY         NULL,
    [crre_Cliente]       CHAR (14)     NULL,
    [crre_Representante] CHAR (3)      NULL,
    [crre_Lock]          BINARY (8)    NULL
);

