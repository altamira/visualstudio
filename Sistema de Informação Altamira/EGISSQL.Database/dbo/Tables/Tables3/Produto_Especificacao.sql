CREATE TABLE [dbo].[Produto_Especificacao] (
    [cd_produto]                INT          NOT NULL,
    [cd_produto_especificacao]  INT          NOT NULL,
    [cd_tipo_especificacao]     INT          NULL,
    [ds_produto_especificacao]  TEXT         NULL,
    [nm_obs_prod_especificacao] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Produto_Especificacao] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_produto_especificacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Especificacao_Tipo_Especificacao_Produto] FOREIGN KEY ([cd_tipo_especificacao]) REFERENCES [dbo].[Tipo_Especificacao_Produto] ([cd_tipo_especificacao])
);

