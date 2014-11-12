CREATE TABLE [dbo].[Faixa_Valor_Pedido_Venda] (
    [cd_faixa_valor]         INT          NOT NULL,
    [nm_faixa_valor]         VARCHAR (40) NULL,
    [qt_ordem_faixa_valor]   INT          NULL,
    [vl_inicial_faixa_valor] FLOAT (53)   NULL,
    [vl_final_faixa_valor]   FLOAT (53)   NULL,
    [nm_obs_faixa_valor]     VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Faixa_Valor_Pedido_Venda] PRIMARY KEY CLUSTERED ([cd_faixa_valor] ASC) WITH (FILLFACTOR = 90)
);

