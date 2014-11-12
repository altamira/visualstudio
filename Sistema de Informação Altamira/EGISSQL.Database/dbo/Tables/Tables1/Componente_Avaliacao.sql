CREATE TABLE [dbo].[Componente_Avaliacao] (
    [cd_componente_avaliacao] INT          NOT NULL,
    [nm_componente_avaliacao] VARCHAR (60) NULL,
    [ds_componente_analise]   TEXT         NULL,
    [ic_ativo_componente]     CHAR (1)     NULL,
    [nm_obs_componente]       VARCHAR (40) NULL,
    [cd_ordem_componente]     INT          NULL,
    [cd_idioma]               INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ds_componente_avaliacao] TEXT         NULL,
    CONSTRAINT [PK_Componente_Avaliacao] PRIMARY KEY CLUSTERED ([cd_componente_avaliacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Componente_Avaliacao_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

