CREATE TABLE [dbo].[OM] (
    [cd_om]                   INT          NOT NULL,
    [dt_om]                   DATETIME     NULL,
    [nm_om]                   VARCHAR (40) NULL,
    [cd_consulta]             INT          NULL,
    [cd_om_motivo]            INT          NULL,
    [ds_obs_om]               TEXT         NULL,
    [cd_vendedor_interno]     INT          NULL,
    [cd_pedido_venda]         INT          NULL,
    [cd_produto]              INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_item_pedido_venda]    INT          NULL,
    [cd_item_consulta]        INT          NULL,
    [qt_item_om]              FLOAT (53)   NULL,
    [ic_movimentado]          CHAR (1)     NULL,
    [cd_id_item_pedido_venda] INT          NULL,
    CONSTRAINT [PK_OM] PRIMARY KEY CLUSTERED ([cd_om] ASC) WITH (FILLFACTOR = 90)
);

