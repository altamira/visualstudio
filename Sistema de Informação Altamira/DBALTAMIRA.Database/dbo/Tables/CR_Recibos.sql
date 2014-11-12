CREATE TABLE [dbo].[CR_Recibos] (
    [crre_Numero]        INT           NOT NULL,
    [crre_DataRecibo]    SMALLDATETIME NOT NULL,
    [crre_Pedido]        INT           NOT NULL,
    [crre_BaseCalculo]   MONEY         NOT NULL,
    [crre_ValorRecibo]   MONEY         NOT NULL,
    [crre_DataBaixaRepr] SMALLDATETIME NULL,
    [crre_Observacao]    VARCHAR (50)  NULL,
    [crre_Observacao2]   VARCHAR (20)  NULL,
    [crre_Comissao]      MONEY         NULL,
    [crre_Cliente]       CHAR (14)     NULL,
    [crre_Representante] CHAR (3)      NULL,
    [crre_Baixado]       CHAR (1)      NULL,
    [crre_Lock]          BINARY (8)    NULL,
    [crre_Parcela]       SMALLINT      NULL,
    CONSTRAINT [PK_CR_Recibos] PRIMARY KEY NONCLUSTERED ([crre_Numero] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_CR_Recibos]
    ON [dbo].[CR_Recibos]([crre_Pedido] ASC) WITH (FILLFACTOR = 90);

