CREATE TABLE [dbo].[Menu_Internet] (
    [cd_menu_internet]     INT           NOT NULL,
    [nm_menu_internet]     VARCHAR (40)  NOT NULL,
    [nm_url_menu_internet] VARCHAR (100) NULL,
    [ic_supervisor]        CHAR (1)      NULL,
    [ic_vendedor]          CHAR (1)      NULL,
    [ic_cliente]           CHAR (1)      NULL,
    [cd_usuario]           INT           NULL,
    [dt_usuario]           DATETIME      NULL
);

