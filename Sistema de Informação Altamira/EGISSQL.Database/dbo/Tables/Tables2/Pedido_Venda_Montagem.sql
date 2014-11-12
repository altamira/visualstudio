CREATE TABLE [dbo].[Pedido_Venda_Montagem] (
    [cd_pedido_venda]       INT        NOT NULL,
    [cd_tipo_montagem]      INT        NULL,
    [cd_montadora]          INT        NULL,
    [pc_comissao_pedido]    FLOAT (53) NULL,
    [ds_montagem]           TEXT       NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    [cd_tipo_embalagem]     INT        NULL,
    [cd_acabamento_produto] INT        NULL,
    CONSTRAINT [PK_Pedido_Venda_Montagem] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC) WITH (FILLFACTOR = 90)
);

