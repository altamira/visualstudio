CREATE TABLE [dbo].[Convenio_Medico] (
    [cd_convenio]          INT          NOT NULL,
    [nm_convenio]          VARCHAR (40) NULL,
    [nm_fantasia_convenio] VARCHAR (15) NULL,
    [ds_perfil_convenio]   TEXT         NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Convenio_Medico] PRIMARY KEY CLUSTERED ([cd_convenio] ASC)
);

