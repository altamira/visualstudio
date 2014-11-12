CREATE TABLE [dbo].[OrcPrc] (
    [numeroOrcamento] CHAR (9)       NOT NULL,
    [base]            NVARCHAR (50)  NULL,
    [lista_precos]    NVARCHAR (100) NULL,
    [idOrcPrc]        INT            IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_OrcPrc] PRIMARY KEY CLUSTERED ([idOrcPrc] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcPrc]
    ON [dbo].[OrcPrc]([numeroOrcamento] ASC, [idOrcPrc] ASC);

