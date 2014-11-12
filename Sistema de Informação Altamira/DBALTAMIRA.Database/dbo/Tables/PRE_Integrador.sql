CREATE TABLE [dbo].[PRE_Integrador] (
    [prit_Integrador]  FLOAT (53)    NOT NULL,
    [prit_Orcamento]   INT           NOT NULL,
    [prit_Quantidade]  MONEY         NULL,
    [prit_IPI]         MONEY         NULL,
    [prit_Valor]       MONEY         NULL,
    [prit_TipoProduto] NVARCHAR (30) NULL,
    [prit_Texto]       NTEXT         NULL
);

