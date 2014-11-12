CREATE TABLE [dbo].[Pedido_Exportacao_Documento] (
    [cd_pedido_venda]          INT           NOT NULL,
    [cd_item_documento_pedido] INT           NOT NULL,
    [cd_tipo_documento_comex]  INT           NULL,
    [nm_obs_documento_pedido]  VARCHAR (100) NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [dt_documento_pedido]      DATETIME      NULL,
    CONSTRAINT [PK_Pedido_Exportacao_Documento] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_documento_pedido] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Exportacao_Documento_Tipo_Documento_Comex] FOREIGN KEY ([cd_tipo_documento_comex]) REFERENCES [dbo].[Tipo_Documento_Comex] ([cd_tipo_documento_comex])
);

