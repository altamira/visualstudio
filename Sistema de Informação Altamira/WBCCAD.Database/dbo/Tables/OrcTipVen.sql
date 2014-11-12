CREATE TABLE [dbo].[OrcTipVen] (
    [PRDGRP_GRUPO]    INT           NULL,
    [TIPOVENDA]       NVARCHAR (50) NULL,
    [numeroOrcamento] NVARCHAR (50) NULL,
    [idOrcTipVen]     INT           IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_OrcTipVen] PRIMARY KEY CLUSTERED ([idOrcTipVen] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcTipVen]
    ON [dbo].[OrcTipVen]([numeroOrcamento] ASC, [idOrcTipVen] ASC);

