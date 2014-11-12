CREATE TABLE [dbo].[Grupo_Aviso_Sistema] (
    [cd_aviso_sistema] INT      NOT NULL,
    [cd_grupo_usuario] INT      NOT NULL,
    [cd_ordem_aviso]   INT      NULL,
    [cd_usuario]       INT      NULL,
    [dt_usuario]       DATETIME NULL,
    CONSTRAINT [PK_Grupo_Aviso_Sistema] PRIMARY KEY CLUSTERED ([cd_aviso_sistema] ASC, [cd_grupo_usuario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Aviso_Sistema_GrupoUsuario] FOREIGN KEY ([cd_grupo_usuario]) REFERENCES [dbo].[GrupoUsuario] ([cd_grupo_usuario])
);

