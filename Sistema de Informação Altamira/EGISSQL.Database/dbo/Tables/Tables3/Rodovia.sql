CREATE TABLE [dbo].[Rodovia] (
    [cd_rodovia]         INT          NOT NULL,
    [nm_rodovia]         VARCHAR (40) NULL,
    [sg_rodovia]         CHAR (10)    NULL,
    [qt_km_rodovia]      FLOAT (53)   NULL,
    [ic_tipo_rodovia]    CHAR (1)     NULL,
    [qt_pedagio_rodovia] FLOAT (53)   NULL,
    [nm_obs_rodovia]     VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Rodovia] PRIMARY KEY CLUSTERED ([cd_rodovia] ASC) WITH (FILLFACTOR = 90)
);

