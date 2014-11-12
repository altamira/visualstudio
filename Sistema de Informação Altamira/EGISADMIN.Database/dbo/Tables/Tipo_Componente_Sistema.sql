CREATE TABLE [dbo].[Tipo_Componente_Sistema] (
    [cd_tipo_componente]          INT          NOT NULL,
    [nm_tipo_componente]          VARCHAR (60) NULL,
    [nm_fantasia_tipo_componente] VARCHAR (25) NOT NULL,
    [ds_tipo_componente]          TEXT         NULL,
    [nm_obs_tipo_componente]      VARCHAR (40) NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Componente_Sistema] PRIMARY KEY CLUSTERED ([cd_tipo_componente] ASC) WITH (FILLFACTOR = 90)
);

