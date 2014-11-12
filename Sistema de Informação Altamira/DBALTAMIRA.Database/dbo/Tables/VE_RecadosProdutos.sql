CREATE TABLE [dbo].[VE_RecadosProdutos] (
    [vepr_Codigo]    SMALLINT     NOT NULL,
    [vepr_Descrição] VARCHAR (50) NULL,
    CONSTRAINT [PK_VE_RecadosProdutos] PRIMARY KEY NONCLUSTERED ([vepr_Codigo] ASC) WITH (FILLFACTOR = 90)
);

