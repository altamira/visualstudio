CREATE TABLE [dbo].[Produto_Unidade_Medida] (
    [cd_produto]               INT          NOT NULL,
    [cd_item_produto_unidade]  INT          NOT NULL,
    [cd_unidade_origem]        INT          NOT NULL,
    [cd_unidade_destino]       INT          NOT NULL,
    [qt_fator_produto_unidade] FLOAT (53)   NOT NULL,
    [ic_sinal_conversao]       CHAR (1)     NULL,
    [vl_custo_produto_unidade] FLOAT (53)   NULL,
    [nm_obs_produto_unidade]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Produto_Unidade_Medida] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_item_produto_unidade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Unidade_Medida_Unidade_Medida] FOREIGN KEY ([cd_unidade_destino]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

