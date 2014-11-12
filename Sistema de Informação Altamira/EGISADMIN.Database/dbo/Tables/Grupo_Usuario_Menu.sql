CREATE TABLE [dbo].[Grupo_Usuario_Menu] (
    [cd_grupo_usuario] INT      NOT NULL,
    [cd_modulo]        INT      NOT NULL,
    [cd_menu]          INT      NOT NULL,
    [cd_usuario]       INT      NULL,
    [dt_usuario]       DATETIME NULL,
    CONSTRAINT [PK_Grupo_Usuario_Menu] PRIMARY KEY CLUSTERED ([cd_grupo_usuario] ASC, [cd_modulo] ASC, [cd_menu] ASC) WITH (FILLFACTOR = 90)
);

