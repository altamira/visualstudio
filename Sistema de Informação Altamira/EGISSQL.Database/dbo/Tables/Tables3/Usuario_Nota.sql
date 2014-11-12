CREATE TABLE [dbo].[Usuario_Nota] (
    [cd_usuario]      INT      NOT NULL,
    [cd_usuario_nota] INT      NOT NULL,
    [dt_usuario_nota] DATETIME NULL,
    [ds_usuario_nota] TEXT     NULL,
    [dt_usuario]      DATETIME NULL,
    CONSTRAINT [PK_Usuario_Nota] PRIMARY KEY CLUSTERED ([cd_usuario] ASC, [cd_usuario_nota] ASC) WITH (FILLFACTOR = 90)
);

