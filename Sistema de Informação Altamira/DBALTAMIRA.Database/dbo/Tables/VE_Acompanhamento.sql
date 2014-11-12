CREATE TABLE [dbo].[VE_Acompanhamento] (
    [veac_Pedido]     INT          NOT NULL,
    [veac_Cliente]    VARCHAR (50) NULL,
    [veac_Entrega]    DATETIME     NULL,
    [veac_Saida]      DATETIME     NULL,
    [veac_Observacao] VARCHAR (50) NULL,
    [veac_Descricao]  VARCHAR (30) NOT NULL,
    [veac_Carteira]   DATETIME     NULL,
    [veac_Banco]      DATETIME     NULL,
    [veac_ComprasE]   DATETIME     NULL,
    [veac_ComprasS]   DATETIME     NULL,
    CONSTRAINT [PK_VE_Acompanhamento] PRIMARY KEY NONCLUSTERED ([veac_Pedido] ASC, [veac_Descricao] ASC) WITH (FILLFACTOR = 90)
);

