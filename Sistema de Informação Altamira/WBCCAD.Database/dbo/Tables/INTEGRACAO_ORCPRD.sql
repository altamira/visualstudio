CREATE TABLE [dbo].[INTEGRACAO_ORCPRD] (
    [ORCNUM]              NVARCHAR (8)  NULL,
    [GRPCOD]              INT           NULL,
    [SUBGRPCOD]           INT           NULL,
    [ORCITM]              INT           NULL,
    [PRDCOD]              NVARCHAR (80) NULL,
    [CORCOD]              NVARCHAR (20) NULL,
    [PRDDSC]              NVARCHAR (70) NULL,
    [ORCQTD]              FLOAT (53)    NULL,
    [ORCTOT]              FLOAT (53)    NULL,
    [ORCPES]              FLOAT (53)    NULL,
    [idIntegracao_OrcPrd] INT           IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_INTEGRACAO_ORCPRD] PRIMARY KEY CLUSTERED ([idIntegracao_OrcPrd] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[INTEGRACAO_ORCPRD] TO [interclick]
    AS [dbo];

