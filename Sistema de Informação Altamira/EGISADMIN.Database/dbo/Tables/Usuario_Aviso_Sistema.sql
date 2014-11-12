CREATE TABLE [dbo].[Usuario_Aviso_Sistema] (
    [cd_aviso_sistema] INT      NOT NULL,
    [cd_usuario_aviso] INT      NOT NULL,
    [cd_ordem_aviso]   INT      NULL,
    [cd_usuario]       INT      NULL,
    [dt_usuario]       DATETIME NULL,
    CONSTRAINT [PK_Usuario_Aviso_Sistema] PRIMARY KEY CLUSTERED ([cd_aviso_sistema] ASC, [cd_usuario_aviso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Usuario_Aviso_Sistema_Usuario] FOREIGN KEY ([cd_usuario_aviso]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

