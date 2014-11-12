CREATE TABLE [dbo].[Manutencao_Pedido_Venda] (
    [cd_manutencao]        INT          NOT NULL,
    [cd_pedido_venda]      INT          NULL,
    [cd_item_pedido_venda] INT          NULL,
    [qt_manutencao]        FLOAT (53)   NULL,
    [cd_produto]           INT          NULL,
    [nm_obs_manutencao]    VARCHAR (60) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [ic_estoque]           CHAR (1)     NULL,
    [ic_alocacao]          CHAR (1)     NULL,
    [dt_entrega]           DATETIME     NULL,
    CONSTRAINT [PK_Manutencao_Pedido_Venda] PRIMARY KEY CLUSTERED ([cd_manutencao] ASC) WITH (FILLFACTOR = 90)
);

