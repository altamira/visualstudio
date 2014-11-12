CREATE TABLE [dbo].[Previa_Faturamento_Composicao] (
    [cd_previa_faturamento]     INT          NOT NULL,
    [cd_item_previa_faturam]    INT          NOT NULL,
    [cd_pedido_venda]           INT          NULL,
    [cd_item_pedido_venda]      INT          NULL,
    [qt_previa_faturamento]     FLOAT (53)   NULL,
    [ic_etiqueta_emb_previa]    CHAR (1)     NULL,
    [nm_obs_item_previa_fatura] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [vl_item_previa_faturam]    FLOAT (53)   NULL,
    [qt_volume_previa_faturam]  FLOAT (53)   NULL,
    [qt_bruto_previa_faturam]   FLOAT (53)   NULL,
    [qt_liquido_previa_faturam] FLOAT (53)   NULL,
    [cd_pallete_previa_faturam] INT          NULL,
    [ic_total_previa_faturam]   CHAR (1)     NULL,
    [ic_fatura_previa_faturam]  CHAR (1)     NULL,
    [cd_programacao_entrega]    INT          NULL,
    CONSTRAINT [PK_Previa_Faturamento_Composicao] PRIMARY KEY CLUSTERED ([cd_previa_faturamento] ASC, [cd_item_previa_faturam] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Previa_Faturamento_Composicao_Pedido_Venda] FOREIGN KEY ([cd_pedido_venda]) REFERENCES [dbo].[Pedido_Venda] ([cd_pedido_venda]) ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [ix_cd_pedido_venda]
    ON [dbo].[Previa_Faturamento_Composicao]([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC) WITH (FILLFACTOR = 90);

