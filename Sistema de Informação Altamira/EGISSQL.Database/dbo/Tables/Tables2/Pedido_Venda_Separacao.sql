CREATE TABLE [dbo].[Pedido_Venda_Separacao] (
    [cd_pedido_venda]        INT          NOT NULL,
    [cd_item_pedido_venda]   INT          NOT NULL,
    [dt_liberacao_separacao] DATETIME     NULL,
    [cd_usuario_liberacao]   INT          NULL,
    [nm_obs_separacao]       VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [dt_separacao]           DATETIME     NULL,
    [cd_usuario_separacao]   INT          NULL,
    CONSTRAINT [PK_Pedido_Venda_Separacao] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC) WITH (FILLFACTOR = 90)
);

