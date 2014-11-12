CREATE TABLE [dbo].[Embarque_Importacao_Parcela] (
    [cd_pedido_importacao]      INT          NOT NULL,
    [cd_embarque]               INT          NOT NULL,
    [cd_parcela_embarque]       INT          NOT NULL,
    [dt_vcto_parcela_embarque]  DATETIME     NULL,
    [vl_parcela_embarque]       FLOAT (53)   NULL,
    [nm_obs_parcela_embarque]   VARCHAR (40) NULL,
    [ic_dt_especifico_embarque] CHAR (1)     NULL,
    [cd_ident_parc_embarque]    VARCHAR (25) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Embarque_Importacao_Parcela] PRIMARY KEY CLUSTERED ([cd_pedido_importacao] ASC, [cd_embarque] ASC, [cd_parcela_embarque] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Embarque_Importacao_Parcela_Pedido_Importacao] FOREIGN KEY ([cd_pedido_importacao]) REFERENCES [dbo].[Pedido_Importacao] ([cd_pedido_importacao])
);

