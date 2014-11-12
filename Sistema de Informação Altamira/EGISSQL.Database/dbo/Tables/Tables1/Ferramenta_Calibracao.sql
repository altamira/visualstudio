CREATE TABLE [dbo].[Ferramenta_Calibracao] (
    [cd_ferramenta]                INT          NOT NULL,
    [cd_local_ferramenta]          INT          NULL,
    [cd_tipo_calibracao]           INT          NULL,
    [cd_frequencia_calibracao]     INT          NULL,
    [nm_modelo_ferramenta]         VARCHAR (40) NULL,
    [nm_marca_ferramenta]          VARCHAR (40) NULL,
    [ds_ferramenta_calibracao]     TEXT         NULL,
    [nm_obs_ferramenta_calibracao] VARCHAR (40) NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    CONSTRAINT [PK_Ferramenta_Calibracao] PRIMARY KEY CLUSTERED ([cd_ferramenta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Ferramenta_Calibracao_Ferramenta] FOREIGN KEY ([cd_ferramenta]) REFERENCES [dbo].[Ferramenta] ([cd_ferramenta])
);

