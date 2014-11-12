CREATE TABLE [dbo].[Grupo_Fmea_Composicao] (
    [cd_grupo_fmea]         INT          NOT NULL,
    [cd_item_grupo_fmea]    INT          NOT NULL,
    [cd_departamento]       INT          NULL,
    [cd_usuario_grupo_fmea] INT          NULL,
    [nm_obs_grupo_fmea]     VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Fmea_Composicao] PRIMARY KEY CLUSTERED ([cd_grupo_fmea] ASC, [cd_item_grupo_fmea] ASC) WITH (FILLFACTOR = 90)
);

