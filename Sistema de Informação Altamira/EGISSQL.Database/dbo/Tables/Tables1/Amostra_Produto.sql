CREATE TABLE [dbo].[Amostra_Produto] (
    [cd_amostra]                   INT          NOT NULL,
    [cd_amostra_produto]           INT          NOT NULL,
    [nm_amostra_produto]           VARCHAR (50) NULL,
    [ds_amostra_produto]           TEXT         NULL,
    [qt_amostra_produto]           FLOAT (53)   NULL,
    [nm_embalagem]                 VARCHAR (50) NULL,
    [cd_unidade_medida]            INT          NULL,
    [nm_fornecedor_atual]          VARCHAR (50) NULL,
    [vl_preco_pago]                FLOAT (53)   NULL,
    [qt_consumo_mensal]            FLOAT (53)   NULL,
    [ic_laudo]                     CHAR (1)     NULL,
    [ic_literatura]                CHAR (1)     NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [qt_densidade_produto_amostra] FLOAT (53)   NULL,
    [cd_tipo_embalagem]            INT          NULL,
    CONSTRAINT [PK_Amostra_Produto] PRIMARY KEY CLUSTERED ([cd_amostra] ASC, [cd_amostra_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Amostra_Produto_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

