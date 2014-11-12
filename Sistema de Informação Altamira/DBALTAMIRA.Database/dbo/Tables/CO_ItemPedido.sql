CREATE TABLE [dbo].[CO_ItemPedido] (
    [coit_Numero]         INT           NOT NULL,
    [coit_Item]           INT           NOT NULL,
    [coit_Quantidade]     MONEY         NOT NULL,
    [coit_Produto]        CHAR (9)      NOT NULL,
    [coit_Discriminacao]  VARCHAR (255) NULL,
    [coit_Unidade]        CHAR (2)      NOT NULL,
    [coit_PrecoUnit]      MONEY         NULL,
    [coit_Preco]          MONEY         NOT NULL,
    [coit_Ipi]            CHAR (6)      NOT NULL,
    [coit_Icms]           CHAR (6)      NOT NULL,
    [coit_Iss]            CHAR (6)      NOT NULL,
    [coit_Destinacao]     CHAR (1)      NOT NULL,
    [coit_DescDestinacao] CHAR (30)     NULL,
    [coit_DataEntrega]    SMALLDATETIME NULL,
    [coit_Lock]           BINARY (8)    NULL,
    CONSTRAINT [PK_CO_ItemPedido] PRIMARY KEY NONCLUSTERED ([coit_Numero] ASC, [coit_Item] ASC) WITH (FILLFACTOR = 90)
);

