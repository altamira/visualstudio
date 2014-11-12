CREATE TABLE [dbo].[Menu_Botao] (
    [cd_menu]    INT      NOT NULL,
    [cd_botao]   INT      NOT NULL,
    [cd_usuario] INT      NULL,
    [dt_usuario] DATETIME NULL,
    CONSTRAINT [PK_Menu_Botao] PRIMARY KEY CLUSTERED ([cd_menu] ASC, [cd_botao] ASC) WITH (FILLFACTOR = 90)
);

