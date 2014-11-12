CREATE TABLE [dbo].[Menu_Teste] (
    [cd_menu]        INT      NOT NULL,
    [cd_plano_teste] INT      NOT NULL,
    [cd_usuario]     INT      NULL,
    [dt_usuario]     DATETIME NULL,
    CONSTRAINT [PK_Menu_Teste] PRIMARY KEY CLUSTERED ([cd_menu] ASC, [cd_plano_teste] ASC) WITH (FILLFACTOR = 90)
);

