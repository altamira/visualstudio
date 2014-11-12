CREATE TABLE [dbo].[Pedido_Venda_Historico] (
    [cd_pedido_venda_historico]   INT          NOT NULL,
    [cd_pedido_venda]             INT          NOT NULL,
    [dt_pedido_venda_historico]   DATETIME     NULL,
    [cd_historico_pedido]         INT          NULL,
    [nm_pedido_venda_histor_1]    VARCHAR (50) NULL,
    [nm_pedido_venda_histor_2]    VARCHAR (50) NULL,
    [nm_pedido_venda_histor_3]    VARCHAR (50) NULL,
    [nm_pedido_venda_histor_4]    VARCHAR (50) NULL,
    [cd_tipo_status_pedido]       INT          NULL,
    [cd_item_pedido_venda]        INT          NULL,
    [cd_modulo]                   INT          NULL,
    [cd_departamento]             INT          NULL,
    [cd_processo]                 INT          NOT NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [nm_pedido_venda_historico_1] VARCHAR (50) NULL,
    [nm_pedido_venda_historico_2] VARCHAR (50) NULL,
    [nm_pedido_venda_historico_3] VARCHAR (50) NULL,
    [nm_pedido_venda_historico_4] VARCHAR (40) NULL,
    CONSTRAINT [PK_Pedido_Venda_Historico] PRIMARY KEY CLUSTERED ([cd_pedido_venda_historico] ASC) WITH (FILLFACTOR = 90)
);

