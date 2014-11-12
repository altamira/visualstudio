CREATE TABLE [dbo].[Menu_Relatorio] (
    [cd_menu]             INT      NOT NULL,
    [cd_modulo]           INT      NOT NULL,
    [cd_relatorio]        INT      NOT NULL,
    [cd_usuario_atualiza] INT      NULL,
    [dt_atualiza]         DATETIME NULL,
    [cd_classe]           INT      NULL,
    [cd_usuario]          INT      NULL,
    [dt_usuario]          DATETIME NULL,
    CONSTRAINT [PK_Menu_Relatorio] PRIMARY KEY CLUSTERED ([cd_menu] ASC, [cd_modulo] ASC, [cd_relatorio] ASC) WITH (FILLFACTOR = 90)
);

