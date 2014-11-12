CREATE TABLE [dbo].[INTEGRACAO_ORCITM] (
    [ORCNUM]              NVARCHAR (8)   NULL,
    [GRPCOD]              INT            NULL,
    [SUBGRPCOD]           INT            NULL,
    [ORCITM]              INT            NULL,
    [ORCPRDCOD]           CHAR (60)      NULL,
    [ORCPRDQTD]           MONEY          NULL,
    [ORCTXT]              VARCHAR (5000) NULL,
    [ORCVAL]              MONEY          NULL,
    [ORCIPI]              MONEY          NULL,
    [ORCICM]              MONEY          NULL,
    [idIntegracao_OrcItm] INT            IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_INTEGRACAO_ORCITM] PRIMARY KEY CLUSTERED ([idIntegracao_OrcItm] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[INTEGRACAO_ORCITM] TO [interclick]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[INTEGRACAO_ORCITM] TO [interclick]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[INTEGRACAO_ORCITM] TO [altanet]
    AS [dbo];

