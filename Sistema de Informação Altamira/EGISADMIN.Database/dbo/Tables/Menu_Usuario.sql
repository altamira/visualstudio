CREATE TABLE [dbo].[Menu_Usuario] (
    [cd_menu]             INT      NOT NULL,
    [cd_modulo]           INT      NOT NULL,
    [cd_usuario]          INT      NOT NULL,
    [cd_nivel_acesso]     INT      NULL,
    [cd_usuario_atualiza] INT      NULL,
    [dt_atualiza]         DATETIME NULL,
    [dt_usuario]          DATETIME NULL,
    CONSTRAINT [PK_Menu_Usuario] PRIMARY KEY CLUSTERED ([cd_menu] ASC, [cd_modulo] ASC, [cd_usuario] ASC) WITH (FILLFACTOR = 90)
);

