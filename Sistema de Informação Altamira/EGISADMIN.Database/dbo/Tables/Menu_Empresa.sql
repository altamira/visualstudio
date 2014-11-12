CREATE TABLE [dbo].[Menu_Empresa] (
    [cd_empresa]          INT          NOT NULL,
    [cd_menu]             INT          NOT NULL,
    [ic_habilitado_menu]  CHAR (1)     NULL,
    [dt_menu_cliente]     DATETIME     NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [nm_obs_menu_cliente] VARCHAR (40) NULL,
    CONSTRAINT [PK_Menu_Empresa] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_menu] ASC) WITH (FILLFACTOR = 90)
);

