CREATE TABLE [dbo].[Tipo_Manut_Sis] (
    [cd_tipo_manut_sis]   INT          NOT NULL,
    [nm_tipo_manut_sis]   VARCHAR (30) NULL,
    [sg_tipo_manut_sis]   CHAR (5)     NULL,
    [cd_imagem]           INT          NULL,
    [cd_usuario_atualiza] INT          NULL,
    [dt_atualiza]         DATETIME     NULL
);

