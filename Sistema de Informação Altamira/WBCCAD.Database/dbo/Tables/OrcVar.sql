CREATE TABLE [dbo].[OrcVar] (
    [idOrcVar]        INT            IDENTITY (1, 1) NOT NULL,
    [numeroOrcamento] CHAR (9)       NOT NULL,
    [Valor]           NVARCHAR (MAX) NULL,
    [Variavel]        NVARCHAR (50)  NULL,
    CONSTRAINT [PK_OrcVar] PRIMARY KEY CLUSTERED ([idOrcVar] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcVar]
    ON [dbo].[OrcVar]([numeroOrcamento] ASC, [idOrcVar] ASC);

