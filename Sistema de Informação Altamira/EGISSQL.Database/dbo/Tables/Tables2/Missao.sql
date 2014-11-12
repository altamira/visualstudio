CREATE TABLE [dbo].[Missao] (
    [cd_missao]        INT          NOT NULL,
    [nm_missao]        VARCHAR (40) NULL,
    [dt_inicio_missao] DATETIME     NULL,
    [dt_fim_missao]    DATETIME     NULL,
    [ds_missao]        TEXT         NULL,
    [cd_igreja]        INT          NULL,
    [cd_pastor]        INT          NULL,
    [cd_pais]          INT          NULL,
    [cd_estado]        INT          NULL,
    [cd_cidade]        INT          NULL,
    [cd_tipo_missao]   INT          NULL,
    [nm_obs_missao]    VARCHAR (40) NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Missao] PRIMARY KEY CLUSTERED ([cd_missao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Missao_Tipo_Missao] FOREIGN KEY ([cd_tipo_missao]) REFERENCES [dbo].[Tipo_Missao] ([cd_tipo_missao])
);

