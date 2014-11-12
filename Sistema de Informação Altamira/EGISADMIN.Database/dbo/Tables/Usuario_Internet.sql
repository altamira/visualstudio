CREATE TABLE [dbo].[Usuario_Internet] (
    [dt_usuario]          DATETIME     NULL,
    [cd_usuario]          INT          NULL,
    [cd_usuario_internet] INT          NOT NULL,
    [ic_vpn_usuario]      CHAR (1)     NULL,
    [cd_vendedor]         INT          NULL,
    [nm_obs_usuario]      VARCHAR (40) NULL,
    CONSTRAINT [PK_Usuario_Internet] PRIMARY KEY CLUSTERED ([cd_usuario_internet] ASC) WITH (FILLFACTOR = 90)
);

