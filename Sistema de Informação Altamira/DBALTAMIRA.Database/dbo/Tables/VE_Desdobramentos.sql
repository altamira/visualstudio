CREATE TABLE [dbo].[VE_Desdobramentos] (
    [vede_Pedido]     INT  NOT NULL,
    [Vede_Item]       INT  NOT NULL,
    [vede_Descrição]  TEXT NULL,
    [vede_NotaFiscal] INT  NULL,
    CONSTRAINT [PK_VE_Desdobramentos] PRIMARY KEY NONCLUSTERED ([vede_Pedido] ASC, [Vede_Item] ASC) WITH (FILLFACTOR = 90)
);

