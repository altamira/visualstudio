CREATE TABLE [dbo].[Tipo_envio] (
    [cd_tipo_envio]        INT          NOT NULL,
    [sg_tipo_envio]        CHAR (10)    NULL,
    [nm_tipo_envio]        VARCHAR (60) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [ic_padrao_tipo_envio] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_envio] PRIMARY KEY CLUSTERED ([cd_tipo_envio] ASC) WITH (FILLFACTOR = 90)
);

