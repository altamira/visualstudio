CREATE TABLE [dbo].[Menu_Cliente] (
    [cd_menu]             INT          NOT NULL,
    [cd_cliente_sistema]  INT          NOT NULL,
    [ic_habilitado_menu]  CHAR (1)     NULL,
    [dt_menu_cliente]     DATETIME     NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [nm_obs_menu_cliente] VARCHAR (40) NULL,
    CONSTRAINT [PK_Menu_Cliente] PRIMARY KEY CLUSTERED ([cd_menu] ASC, [cd_cliente_sistema] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Menu_Cliente_Cliente_Sistema] FOREIGN KEY ([cd_cliente_sistema]) REFERENCES [dbo].[Cliente_Sistema] ([cd_cliente_sistema])
);

