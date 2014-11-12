CREATE TABLE [dbo].[Percurso] (
    [cd_percurso]           INT          NOT NULL,
    [nm_percurso]           VARCHAR (60) NULL,
    [cd_local_origem]       INT          NULL,
    [cd_local_destino]      INT          NULL,
    [qt_km_percurso]        FLOAT (53)   NULL,
    [qt_distancia_percurso] FLOAT (53)   NULL,
    [nm_obs_percurso]       VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [qt_km_padrao_percurso] FLOAT (53)   NULL,
    CONSTRAINT [PK_Percurso] PRIMARY KEY CLUSTERED ([cd_percurso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Percurso_Local_Percurso] FOREIGN KEY ([cd_local_destino]) REFERENCES [dbo].[Local_Percurso] ([cd_local_percurso])
);

