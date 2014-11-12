CREATE TABLE [dbo].[OrcMatDetAdicional] (
    [idOrcMatDetAdicional] INT            IDENTITY (1, 1) NOT NULL,
    [idOrcMatDet]          INT            NULL,
    [chave]                NVARCHAR (255) NULL,
    [base]                 MONEY          NULL,
    [fator]                FLOAT (53)     NULL,
    [redutor]              FLOAT (53)     NULL,
    [valor]                MONEY          NULL,
    [markup]               INT            NULL,
    [formula]              TEXT           NULL,
    [numeroOrcamento]      NCHAR (9)      NULL,
    CONSTRAINT [PK_OrcMatDetAdicional] PRIMARY KEY CLUSTERED ([idOrcMatDetAdicional] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcMatDetAdicional]
    ON [dbo].[OrcMatDetAdicional]([numeroOrcamento] ASC, [idOrcMatDetAdicional] ASC);

