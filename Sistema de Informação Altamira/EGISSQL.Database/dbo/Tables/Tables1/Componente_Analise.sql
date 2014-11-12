CREATE TABLE [dbo].[Componente_Analise] (
    [cd_componente_analise]      INT          NOT NULL,
    [nm_componente_analise]      VARCHAR (60) NULL,
    [ds_componente_analise]      TEXT         NULL,
    [ic_ativo_componente]        CHAR (1)     NULL,
    [nm_obs_componente]          VARCHAR (40) NULL,
    [cd_ordem_componente]        INT          NULL,
    [cd_idioma]                  INT          NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [ic_tipo_componente_analise] CHAR (1)     NULL,
    CONSTRAINT [PK_Componente_Analise] PRIMARY KEY CLUSTERED ([cd_componente_analise] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Componente_Analise_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

