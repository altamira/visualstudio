CREATE TABLE [dbo].[tipo_validacao] (
    [cd_tipo_validacao] INT           NOT NULL,
    [nm_tipo_validacao] VARCHAR (40)  NULL,
    [sg_tipo_validacao] CHAR (10)     NULL,
    [ds_tipo_validacao] VARCHAR (256) NULL,
    [cd_usuario]        INT           NULL,
    [dt_usuario]        DATETIME      NULL
);

