CREATE TABLE [dbo].[Usuario_Modulo] (
    [cd_modulo]           INT      NOT NULL,
    [cd_usuario]          INT      NOT NULL,
    [cd_usuario_atualiza] INT      NULL,
    [dt_atualiza]         DATETIME NULL,
    [dt_usuario]          DATETIME NULL
);

