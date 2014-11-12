CREATE TABLE [dbo].[logistica_varejo] (
    [cd_pedido_venda]       INT          NOT NULL,
    [cd_item_pedido_venda]  INT          NOT NULL,
    [cd_tipo_local_entrega] INT          NULL,
    [cd_requisicao_compra]  INT          NULL,
    [cd_pedido_compra]      INT          NULL,
    [cd_local_saida]        INT          NULL,
    [hr_entrega]            VARCHAR (8)  NULL,
    [cd_tipo_entrega]       INT          NULL,
    [ic_entrega]            CHAR (1)     NULL,
    [nm_obs_entrega]        VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_status_entrega]     CHAR (1)     NULL,
    [ic_local_saida]        CHAR (1)     NULL,
    CONSTRAINT [PK_logistica_varejo] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC) WITH (FILLFACTOR = 90)
);

