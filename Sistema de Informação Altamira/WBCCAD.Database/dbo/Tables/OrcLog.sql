CREATE TABLE [dbo].[OrcLog] (
    [numeroOrcamento] CHAR (9)       NOT NULL,
    [orclog_data]     DATETIME       NULL,
    [orclog_time]     DATETIME       NULL,
    [orclog_usuario]  NVARCHAR (20)  NULL,
    [orclog_nr_seq]   INT            IDENTITY (1, 1) NOT NULL,
    [orclog_linha]    NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_OrcLog] PRIMARY KEY CLUSTERED ([orclog_nr_seq] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcLog]
    ON [dbo].[OrcLog]([numeroOrcamento] ASC, [orclog_nr_seq] ASC);

