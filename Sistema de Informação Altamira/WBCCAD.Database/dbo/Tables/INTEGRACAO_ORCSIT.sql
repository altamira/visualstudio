CREATE TABLE [dbo].[INTEGRACAO_ORCSIT] (
    [ORCNUM]              NVARCHAR (8) NULL,
    [SITCOD]              INT          NULL,
    [ORCALTDTH]           DATETIME     NULL,
    [idIntegracao_OrcSit] INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_INTEGRACAO_ORCSIT] PRIMARY KEY CLUSTERED ([idIntegracao_OrcSit] ASC)
);


GO
GRANT UPDATE
    ON OBJECT::[dbo].[INTEGRACAO_ORCSIT] TO [gestao]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[INTEGRACAO_ORCSIT] TO [interclick]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[INTEGRACAO_ORCSIT] TO [interclick]
    AS [dbo];

