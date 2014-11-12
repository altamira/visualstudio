CREATE TABLE [dbo].[LogAcesso] (
    [dt_log_acesso]       DATETIME  NOT NULL,
    [cd_usuario]          INT       NOT NULL,
    [cd_menu]             INT       NOT NULL,
    [cd_modulo]           INT       NOT NULL,
    [sg_log_acesso]       CHAR (10) NULL,
    [cd_usuario_atualiza] INT       NULL,
    [dt_atualiza]         DATETIME  NULL
);

