CREATE TABLE [dbo].[PRE_FormacaoProv] (
    [fopv_CodFilho]   VARCHAR (20) NOT NULL,
    [fopv_Descrição]  TEXT         NULL,
    [fopv_Quantidade] INT          NULL,
    CONSTRAINT [PK_PRE_FormacaoProv] PRIMARY KEY NONCLUSTERED ([fopv_CodFilho] ASC) WITH (FILLFACTOR = 90)
);

