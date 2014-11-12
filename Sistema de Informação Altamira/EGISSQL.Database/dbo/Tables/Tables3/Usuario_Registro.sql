CREATE TABLE [dbo].[Usuario_Registro] (
    [cd_controle_registro] INT      NOT NULL,
    [cd_usuario_registro]  INT      NOT NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Usuario_Registro] PRIMARY KEY CLUSTERED ([cd_controle_registro] ASC),
    CONSTRAINT [FK_Usuario_Registro_Usuario] FOREIGN KEY ([cd_usuario_registro]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

