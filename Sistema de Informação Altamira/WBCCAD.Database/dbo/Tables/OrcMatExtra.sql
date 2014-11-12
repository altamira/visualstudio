CREATE TABLE [dbo].[OrcMatExtra] (
    [idOrcMatExtra]       INT            NOT NULL,
    [codigoProduto]       NVARCHAR (100) NULL,
    [corProduto]          NVARCHAR (50)  NULL,
    [grupo]               NVARCHAR (2)   NULL,
    [subgrupo]            NVARCHAR (2)   NULL,
    [corte]               NVARCHAR (100) NULL,
    [id]                  NVARCHAR (50)  NULL,
    [departamento]        NVARCHAR (255) NULL,
    [setor]               NVARCHAR (255) NULL,
    [utilizacao]          NVARCHAR (255) NULL,
    [quantidade]          FLOAT (53)     NULL,
    [quantidadeUtilizada] FLOAT (53)     NULL,
    [numeroOrcamento]     NCHAR (9)      NULL,
    [item]                VARCHAR (20)   NULL,
    CONSTRAINT [PK_OrcMatExtra] PRIMARY KEY CLUSTERED ([idOrcMatExtra] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcMatExtra]
    ON [dbo].[OrcMatExtra]([numeroOrcamento] ASC, [idOrcMatExtra] ASC);

