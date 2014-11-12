CREATE TABLE [dbo].[Pedido_Venda_Status] (
    [cd_pedido_venda]  INT      NOT NULL,
    [ic_status_pedido] CHAR (1) NULL,
    [cd_usuario]       INT      NULL,
    [dt_usuario]       DATETIME NULL,
    CONSTRAINT [PK_Pedido_Venda_Status] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC) WITH (FILLFACTOR = 90)
);

