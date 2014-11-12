CREATE TABLE [dbo].[Revenda_Sistema] (
    [cd_revenda]          INT           NOT NULL,
    [nm_revenda]          VARCHAR (40)  NULL,
    [sg_revenda]          CHAR (10)     NULL,
    [nm_fantasia_revenda] VARCHAR (15)  NULL,
    [nm_site_revenda]     VARCHAR (100) NULL,
    [ds_perfil_revenda]   TEXT          NULL,
    [cd_regiao_venda]     INT           NULL,
    [nm_obs_revenda]      VARCHAR (40)  NULL,
    [cd_usuario]          INT           NULL,
    [dt_usuario]          DATETIME      NULL,
    CONSTRAINT [PK_Revenda_Sistema] PRIMARY KEY CLUSTERED ([cd_revenda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Revenda_Sistema_Regiao_Venda] FOREIGN KEY ([cd_regiao_venda]) REFERENCES [dbo].[Regiao_Venda] ([cd_regiao_venda])
);

