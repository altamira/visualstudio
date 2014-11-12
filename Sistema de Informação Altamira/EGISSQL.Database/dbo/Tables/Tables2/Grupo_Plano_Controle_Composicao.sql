CREATE TABLE [dbo].[Grupo_Plano_Controle_Composicao] (
    [cd_grupo_plano_controle]   INT          NOT NULL,
    [cd_item_grupo_controle]    INT          NOT NULL,
    [cd_departamento]           INT          NULL,
    [cd_usuario_grupo_controle] INT          NULL,
    [nm_obs_grupo_controle]     VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Plano_Controle_Composicao] PRIMARY KEY CLUSTERED ([cd_grupo_plano_controle] ASC, [cd_item_grupo_controle] ASC) WITH (FILLFACTOR = 90)
);

