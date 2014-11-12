CREATE TABLE [dbo].[SPED_Tipo_Plano] (
    [cd_tipo_plano] INT          NOT NULL,
    [nm_tipo_plano] VARCHAR (60) NULL,
    [sg_tipo_plano] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_SPED_Tipo_Plano] PRIMARY KEY CLUSTERED ([cd_tipo_plano] ASC)
);

