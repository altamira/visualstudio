CREATE TABLE [dbo].[CO_Pedido] (
    [cope_Numero]                INT           NOT NULL,
    [cope_Data]                  SMALLDATETIME NOT NULL,
    [cope_Fornecedor]            CHAR (14)     NOT NULL,
    [cope_Condicoes]             CHAR (30)     NOT NULL,
    [cope_TipoPreco]             CHAR (1)      NOT NULL,
    [cope_Reajuste]              CHAR (10)     NULL,
    [cope_Imobilizado]           CHAR (9)      NULL,
    [cope_Observacao]            VARCHAR (100) NULL,
    [cope_Status]                CHAR (1)      NOT NULL,
    [cope_TipoPedido]            CHAR (1)      NOT NULL,
    [cope_ValorSubTotal]         MONEY         NULL,
    [cope_ValorIPIISS]           MONEY         NULL,
    [cope_ValorTotal]            MONEY         NULL,
    [cope_TipoMP]                CHAR (3)      NULL,
    [cope_DataDaBaixa]           SMALLDATETIME NULL,
    [cope_ObservacãoAbatimento]  TEXT          NULL,
    [cope_Prorrogação]           INT           NULL,
    [cope_ObservaçãoProrrogação] TEXT          NULL,
    [cope_Lock]                  ROWVERSION    NOT NULL,
    CONSTRAINT [PK_CO_Pedido_1__13] PRIMARY KEY CLUSTERED ([cope_Numero] ASC) WITH (FILLFACTOR = 90)
);

