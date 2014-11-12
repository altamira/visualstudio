CREATE TABLE [dbo].[RNC_Laudo] (
    [cd_rnc]                    INT           NOT NULL,
    [cd_caracteristica_laudo]   INT           NOT NULL,
    [nm_especificacao_rnc]      VARCHAR (100) NULL,
    [nm_metodo_rnc]             VARCHAR (100) NULL,
    [nm_resultado_rnc]          VARCHAR (100) NULL,
    [qt_resultado_rnc]          FLOAT (53)    NULL,
    [nm_obs_caracteristica_rnc] VARCHAR (60)  NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    CONSTRAINT [PK_RNC_Laudo] PRIMARY KEY CLUSTERED ([cd_rnc] ASC, [cd_caracteristica_laudo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RNC_Laudo_Caracteristica_Laudo] FOREIGN KEY ([cd_caracteristica_laudo]) REFERENCES [dbo].[Caracteristica_Laudo] ([cd_caracteristica_laudo])
);

