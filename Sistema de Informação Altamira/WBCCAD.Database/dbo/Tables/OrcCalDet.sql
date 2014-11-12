CREATE TABLE [dbo].[OrcCalDet] (
    [idOrcCalDet]     INT            IDENTITY (1, 1) NOT NULL,
    [TipoCalculo]     NVARCHAR (255) NULL,
    [idGrupo]         INT            NULL,
    [Valor]           NVARCHAR (100) NULL,
    [TotalLista]      MONEY          NULL,
    [TotalVenda]      MONEY          NULL,
    [numeroOrcamento] NCHAR (9)      NULL,
    CONSTRAINT [PK_OrcCalDet] PRIMARY KEY CLUSTERED ([idOrcCalDet] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcCalDet]
    ON [dbo].[OrcCalDet]([numeroOrcamento] ASC, [idOrcCalDet] ASC);

