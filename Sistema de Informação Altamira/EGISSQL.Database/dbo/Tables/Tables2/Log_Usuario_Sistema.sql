CREATE TABLE [dbo].[Log_Usuario_Sistema] (
    [cd_cliente_sistema] INT      NOT NULL,
    [cd_usuario_sistema] INT      NOT NULL,
    [dt_acesso_usuario]  DATETIME NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    CONSTRAINT [PK_Log_Usuario_Sistema] PRIMARY KEY CLUSTERED ([cd_cliente_sistema] ASC, [cd_usuario_sistema] ASC) WITH (FILLFACTOR = 90)
);

