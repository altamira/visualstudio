CREATE TABLE [dbo].[Produto_Orcamento_Furo] (
    [cd_produto]             INT          NULL,
    [cd_placa]               INT          NULL,
    [cd_item_orcamento_furo] INT          NOT NULL,
    [cd_tipo_furo]           INT          NULL,
    [qt_furo_produto_placa]  FLOAT (53)   NULL,
    [nm_obs_orcamento_furo]  VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Produto_Orcamento_Furo] PRIMARY KEY CLUSTERED ([cd_item_orcamento_furo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Orcamento_Furo_Placa] FOREIGN KEY ([cd_placa]) REFERENCES [dbo].[Placa] ([cd_placa]),
    CONSTRAINT [FK_Produto_Orcamento_Furo_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto]),
    CONSTRAINT [FK_Produto_Orcamento_Furo_Tipo_Furo] FOREIGN KEY ([cd_tipo_furo]) REFERENCES [dbo].[Tipo_Furo] ([cd_tipo_furo])
);

