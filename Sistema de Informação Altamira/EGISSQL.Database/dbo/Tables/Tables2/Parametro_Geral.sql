CREATE TABLE [dbo].[Parametro_Geral] (
    [cd_empresa]                INT          NOT NULL,
    [ic_pessoal_empresa]        CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_tipo_periodo]           INT          NULL,
    [nm_obs_parametro_geral]    VARCHAR (40) NULL,
    [ic_centro_receita_empresa] CHAR (1)     NULL,
    [ic_centro_custo_empresa]   CHAR (1)     NULL
);

