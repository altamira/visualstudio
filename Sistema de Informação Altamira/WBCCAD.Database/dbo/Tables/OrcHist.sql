CREATE TABLE [dbo].[OrcHist] (
    [idOrcHist]         INT            IDENTITY (1, 1) NOT NULL,
    [numeroOrcamento]   CHAR (9)       NULL,
    [orchist_historico] NVARCHAR (255) NULL,
    CONSTRAINT [PK_OrcHist] PRIMARY KEY CLUSTERED ([idOrcHist] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcHist]
    ON [dbo].[OrcHist]([idOrcHist] ASC, [numeroOrcamento] ASC);

