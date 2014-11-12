CREATE TABLE [dbo].[VE_RecadosSelProdutos] (
    [vese_CodRecado]  CHAR (11)    NOT NULL,
    [vese_CodProduto] SMALLINT     NOT NULL,
    [vese_Descrição]  VARCHAR (50) NULL,
    CONSTRAINT [PK_VE_RecadosSelProdutos] PRIMARY KEY NONCLUSTERED ([vese_CodRecado] ASC, [vese_CodProduto] ASC) WITH (FILLFACTOR = 90)
);

