CREATE TABLE [dbo].[Parametro_Bem_Centro_Custo] (
    [cd_parametro_bem]     INT          NOT NULL,
    [cd_empresa]           INT          NULL,
    [cd_centro_custo]      INT          NOT NULL,
    [cd_localizacao_bem]   INT          NULL,
    [cd_planta]            INT          NULL,
    [cd_departamento]      INT          NULL,
    [cd_tipo_bem]          INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [nm_obs_parametro_bem] VARCHAR (40) NULL,
    CONSTRAINT [PK_Parametro_Bem_Centro_Custo] PRIMARY KEY CLUSTERED ([cd_parametro_bem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Bem_Centro_Custo_Tipo_Bem] FOREIGN KEY ([cd_tipo_bem]) REFERENCES [dbo].[Tipo_Bem] ([cd_tipo_bem])
);

