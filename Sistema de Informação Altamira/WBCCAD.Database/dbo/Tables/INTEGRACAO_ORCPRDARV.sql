CREATE TABLE [dbo].[INTEGRACAO_ORCPRDARV] (
    [ORCNUM]                 NVARCHAR (8)  NULL,
    [GRPCOD]                 INT           NULL,
    [SUBGRPCOD]              INT           NULL,
    [ORCITM]                 INT           NULL,
    [PRDCOD]                 NVARCHAR (80) NULL,
    [ORCPRDARV_NIVEL]        INT           NULL,
    [CORCOD]                 NVARCHAR (20) NULL,
    [PRDDSC]                 NVARCHAR (70) NULL,
    [ORCQTD]                 FLOAT (53)    NULL,
    [ORCTOT]                 FLOAT (53)    NULL,
    [ORCPES]                 FLOAT (53)    NULL,
    [idIntegracao_OrcPrdArv] INT           IDENTITY (1, 1) NOT NULL,
    [orcprdarv_dth]          DATETIME      NULL,
    CONSTRAINT [PK_INTEGRACAO_ORCPRDARV] PRIMARY KEY CLUSTERED ([idIntegracao_OrcPrdArv] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[INTEGRACAO_ORCPRDARV] TO [interclick]
    AS [dbo];

