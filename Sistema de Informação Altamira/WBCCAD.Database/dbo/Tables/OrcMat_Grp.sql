CREATE TABLE [dbo].[OrcMat_Grp] (
    [idOrcMatGrp]         INT            IDENTITY (1, 1) NOT NULL,
    [orcmat_grp_codigo]   NVARCHAR (100) NULL,
    [orcmat_grp_cor]      NVARCHAR (20)  NULL,
    [orcmat_grp_grupo]    INT            NULL,
    [orcmat_grp_qtde]     FLOAT (53)     NULL,
    [orcmat_grp_subgrupo] CHAR (2)       NULL,
    [numeroOrcamento]     NCHAR (9)      NULL,
    CONSTRAINT [PK_OrcMat_Grp] PRIMARY KEY CLUSTERED ([idOrcMatGrp] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcMat_Grp]
    ON [dbo].[OrcMat_Grp]([numeroOrcamento] ASC, [idOrcMatGrp] ASC);

