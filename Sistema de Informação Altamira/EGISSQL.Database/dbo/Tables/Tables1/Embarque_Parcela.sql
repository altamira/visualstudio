CREATE TABLE [dbo].[Embarque_Parcela] (
    [cd_pedido_venda]            INT          NOT NULL,
    [cd_embarque]                INT          NOT NULL,
    [cd_parcela_embarque]        INT          NOT NULL,
    [dt_vcto_parcela_embarque]   DATETIME     NULL,
    [vl_parcela_embarque]        FLOAT (53)   NULL,
    [nm_obs_parcela_embarque]    VARCHAR (40) NULL,
    [ic_dt_especirfico_embarque] CHAR (1)     NULL,
    [cd_ident_parc_embarque]     VARCHAR (25) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Embarque_Parcela] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_embarque] ASC, [cd_parcela_embarque] ASC) WITH (FILLFACTOR = 90)
);

