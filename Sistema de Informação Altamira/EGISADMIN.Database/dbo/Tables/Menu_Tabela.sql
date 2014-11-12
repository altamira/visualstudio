CREATE TABLE [dbo].[Menu_Tabela] (
    [cd_menu]                 INT      NOT NULL,
    [cd_tabela]               INT      NOT NULL,
    [ic_abre_automatico_form] CHAR (1) NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    [ic_alteracao]            CHAR (1) NULL,
    CONSTRAINT [PK_Menu_Tabela] PRIMARY KEY CLUSTERED ([cd_menu] ASC, [cd_tabela] ASC) WITH (FILLFACTOR = 90)
);

