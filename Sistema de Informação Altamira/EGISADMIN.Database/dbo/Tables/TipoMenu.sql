CREATE TABLE [dbo].[TipoMenu] (
    [cd_tipo_menu]        INT          NOT NULL,
    [nm_tipo_menu]        VARCHAR (40) NULL,
    [sg_tipo_menu]        CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [CD_USUARIO_ATUALIZA] INT          NULL,
    [DT_ATUALIZA]         DATETIME     NULL,
    [cd_cep]              INT          NULL
);

