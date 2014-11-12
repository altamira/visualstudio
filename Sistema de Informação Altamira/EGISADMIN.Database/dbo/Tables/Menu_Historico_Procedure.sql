CREATE TABLE [dbo].[Menu_Historico_Procedure] (
    [cd_menu_historico]           INT           NOT NULL,
    [cd_menu_historico_procedure] INT           NOT NULL,
    [nm_procedure]                VARCHAR (500) NULL,
    CONSTRAINT [PK_Menu_Historico_Procedure] PRIMARY KEY CLUSTERED ([cd_menu_historico] ASC, [cd_menu_historico_procedure] ASC) WITH (FILLFACTOR = 90)
);

