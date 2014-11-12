CREATE TABLE [dbo].[Laudo_Amostra] (
    [cd_laudo]             INT          NOT NULL,
    [qt_amostra_laudo]     FLOAT (53)   NULL,
    [qt_aprovado]          FLOAT (53)   NULL,
    [qt_reprovado]         FLOAT (53)   NULL,
    [cd_status_inspecao]   INT          NULL,
    [nm_obs_laudo_amostra] VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Laudo_Amostra] PRIMARY KEY CLUSTERED ([cd_laudo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Laudo_Amostra_Laudo] FOREIGN KEY ([cd_laudo]) REFERENCES [dbo].[Laudo] ([cd_laudo])
);

