CREATE TABLE [dbo].[Usuario_Info_Gerencial] (
    [cd_usuario_info_gerencial] INT      NOT NULL,
    [cd_info_gerencial]         INT      NOT NULL,
    [ic_gera_email]             CHAR (1) NOT NULL,
    [qt_dia_gera_email]         INT      NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Usuario_Info_Gerencial] PRIMARY KEY CLUSTERED ([cd_usuario_info_gerencial] ASC, [cd_info_gerencial] ASC) WITH (FILLFACTOR = 90)
);

