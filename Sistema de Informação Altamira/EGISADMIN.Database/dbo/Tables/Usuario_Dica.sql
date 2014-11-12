CREATE TABLE [dbo].[Usuario_Dica] (
    [cd_modulo]  INT      NOT NULL,
    [cd_dica]    INT      NOT NULL,
    [cd_usuario] INT      NOT NULL,
    [dt_usuario] DATETIME NOT NULL,
    CONSTRAINT [PK_Usuario_Dica] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_dica] ASC, [cd_usuario] ASC) WITH (FILLFACTOR = 90)
);

