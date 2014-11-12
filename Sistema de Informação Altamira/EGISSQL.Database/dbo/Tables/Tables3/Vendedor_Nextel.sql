CREATE TABLE [dbo].[Vendedor_Nextel] (
    [cd_vendedor]              INT          NOT NULL,
    [nm_login_vendedor_nextel] VARCHAR (6)  NULL,
    [cd_senha_vendedor_nextel] VARCHAR (6)  NULL,
    [cd_fone_vendedor_nextel]  VARCHAR (20) NULL,
    [nm_obs_vendedor_nextel]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_exporta_vendedor]      CHAR (1)     NULL,
    CONSTRAINT [PK_Vendedor_Nextel] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Vendedor_Nextel_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

