CREATE TABLE [dbo].[MODCTRCAB] (
    [CMod0Tab]       CHAR (200)   NOT NULL,
    [CMod0Id]        CHAR (250)   NOT NULL,
    [CMod0DtH]       DATETIME     NOT NULL,
    [CMod0AcessoFim] SMALLINT     NULL,
    [CMod0AcessoNum] DECIMAL (12) NULL,
    PRIMARY KEY CLUSTERED ([CMod0Tab] ASC, [CMod0Id] ASC, [CMod0DtH] ASC)
);

