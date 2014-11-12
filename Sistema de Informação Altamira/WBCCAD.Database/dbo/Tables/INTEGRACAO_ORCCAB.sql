CREATE TABLE [dbo].[INTEGRACAO_ORCCAB] (
    [ORCNUM]              NVARCHAR (8)   NULL,
    [SITCOD]              INT            NULL,
    [ORCALTDTH]           DATETIME       NULL,
    [ORCVALVND]           MONEY          NULL,
    [ORCVALLST]           MONEY          NULL,
    [ORCVALINV]           MONEY          NULL,
    [ORCVALLUC]           MONEY          NULL,
    [ORCVALEXP]           MONEY          NULL,
    [ORCVALCOM]           MONEY          NULL,
    [ORCPERCOM]           MONEY          NULL,
    [REPCOD]              NVARCHAR (20)  NULL,
    [CLICOD]              INT            NULL,
    [CLINOM]              NVARCHAR (50)  NULL,
    [CLICONCOD]           INT            NULL,
    [CLICON]              NVARCHAR (50)  NULL,
    [ORCVALTRP]           MONEY          NULL,
    [ORCVALEMB]           MONEY          NULL,
    [ORCVALMON]           MONEY          NULL,
    [PGTCOD]              NVARCHAR (MAX) NULL,
    [TIPMONCOD]           NVARCHAR (255) NULL,
    [PRZENT]              INT            NULL,
    [ORCBAS1]             MONEY          NULL,
    [ORCBAS2]             MONEY          NULL,
    [ORCBAS3]             MONEY          NULL,
    [ORCPGT]              NVARCHAR (MAX) NULL,
    [idIntegracao_OrcCab] INT            IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_INTEGRACAO_ORCCAB] PRIMARY KEY CLUSTERED ([idIntegracao_OrcCab] ASC)
);


GO
GRANT UPDATE
    ON OBJECT::[dbo].[INTEGRACAO_ORCCAB] TO [gestao]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[INTEGRACAO_ORCCAB] TO [interclick]
    AS [dbo];

