CREATE TABLE [dbo].[Pedido_Cronograma] (
    [cd_pedido_cronograma]     INT          NOT NULL,
    [cd_pedido_venda]          INT          NULL,
    [cd_item_pedido_venda]     INT          NULL,
    [dt_prevista_cronograma]   DATETIME     NULL,
    [dt_atual_cronograma]      DATETIME     NULL,
    [cd_fase_producao]         INT          NULL,
    [nm_obs_pedido_cronograma] VARCHAR (60) NULL,
    [ds_obs_pedido_cronograma] TEXT         NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_situacao_fase]         INT          NULL,
    [dt_real_cronograma]       DATETIME     NULL,
    [cd_interface]             INT          NULL,
    CONSTRAINT [PK_Pedido_Cronograma] PRIMARY KEY CLUSTERED ([cd_pedido_cronograma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Cronograma_Situacao_Fase] FOREIGN KEY ([cd_situacao_fase]) REFERENCES [dbo].[Situacao_Fase] ([cd_situacao_fase])
);

