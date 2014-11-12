CREATE TABLE [dbo].[Tipo_Retalho] (
    [cd_tipo_retalho]          INT          NOT NULL,
    [nm_tipo_retalho]          VARCHAR (40) NULL,
    [sg_tipo_retalho]          CHAR (10)    NULL,
    [nm_obs_tipo_retalho]      VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [qt_limite_minimo_retalho] FLOAT (53)   NULL,
    CONSTRAINT [PK_Tipo_Retalho] PRIMARY KEY CLUSTERED ([cd_tipo_retalho] ASC) WITH (FILLFACTOR = 90)
);

