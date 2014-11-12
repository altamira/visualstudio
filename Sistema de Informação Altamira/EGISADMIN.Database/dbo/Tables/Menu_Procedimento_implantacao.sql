CREATE TABLE [dbo].[Menu_Procedimento_implantacao] (
    [cd_menu_proc_implantacao] INT      NOT NULL,
    [cd_menu]                  INT      NOT NULL,
    [ds_menu_proc_implantacao] TEXT     NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    CONSTRAINT [PK_Menu_Procedimento_implantacao] PRIMARY KEY CLUSTERED ([cd_menu_proc_implantacao] ASC, [cd_menu] ASC) WITH (FILLFACTOR = 90)
);

