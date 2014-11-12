CREATE TABLE [dbo].[Menu_GrupoUsuario] (
    [cd_grupo_usuario]    INT      NOT NULL,
    [cd_modulo]           INT      NOT NULL,
    [cd_menu]             INT      NOT NULL,
    [cd_nivel_acesso]     INT      NULL,
    [cd_usuario_atualiza] INT      NULL,
    [dt_atualiza]         DATETIME NULL,
    CONSTRAINT [PK_Menu_GrupoUsuario] PRIMARY KEY CLUSTERED ([cd_grupo_usuario] ASC, [cd_modulo] ASC, [cd_menu] ASC) WITH (FILLFACTOR = 90)
);

