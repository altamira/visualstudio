CREATE TABLE [dbo].[OrcVarUsr] (
    [idOrcVarUsr]     INT            IDENTITY (1, 1) NOT NULL,
    [numeroOrcamento] CHAR (9)       NOT NULL,
    [varusrcodigo]    NVARCHAR (50)  NULL,
    [varusrvalor]     NVARCHAR (255) NULL,
    [RECALCULAR]      BIT            NOT NULL,
    CONSTRAINT [PK_OrcVarUsr] PRIMARY KEY CLUSTERED ([idOrcVarUsr] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcVarUsr]
    ON [dbo].[OrcVarUsr]([numeroOrcamento] ASC, [idOrcVarUsr] ASC);

