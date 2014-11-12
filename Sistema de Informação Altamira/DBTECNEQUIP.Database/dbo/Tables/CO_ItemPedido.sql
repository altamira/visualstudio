CREATE TABLE [dbo].[CO_ItemPedido] (
    [coit_Numero]         INT             NOT NULL,
    [coit_Item]           TINYINT         NOT NULL,
    [coit_Quantidade]     NUMERIC (18, 3) NOT NULL,
    [coit_Produto]        CHAR (9)        NOT NULL,
    [coit_Discriminacao]  VARCHAR (100)   NULL,
    [coit_Unidade]        CHAR (2)        NOT NULL,
    [coit_PrecoUnit]      MONEY           NULL,
    [coit_Preco]          MONEY           NOT NULL,
    [coit_Ipi]            CHAR (2)        NOT NULL,
    [coit_Icms]           CHAR (2)        NOT NULL,
    [coit_Iss]            CHAR (2)        NOT NULL,
    [coit_Destinacao]     CHAR (1)        NOT NULL,
    [coit_DescDestinacao] CHAR (30)       NULL,
    [coit_DataEntrega]    SMALLDATETIME   NULL,
    [coit_Lock]           ROWVERSION      NOT NULL,
    CONSTRAINT [PK_CO_ItemPedido_1__13] PRIMARY KEY CLUSTERED ([coit_Numero] ASC, [coit_Item] ASC) WITH (FILLFACTOR = 90)
);

