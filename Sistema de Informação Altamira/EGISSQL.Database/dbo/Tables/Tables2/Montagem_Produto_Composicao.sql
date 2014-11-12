CREATE TABLE [dbo].[Montagem_Produto_Composicao] (
    [cd_montagem_produto]        INT          NOT NULL,
    [cd_item_montagem_produto]   INT          NOT NULL,
    [nm_item_montagem_produto]   VARCHAR (60) NULL,
    [nm_item_fantasia_montagem]  VARCHAR (30) NULL,
    [ic_item_ativo_montagem]     CHAR (1)     NULL,
    [cd_ordem_item_montagem]     INT          NULL,
    [ds_item_montagem]           TEXT         NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [cd_Item_mascara_montagem]   VARCHAR (30) NULL,
    [nm_montagem_produto]        VARCHAR (60) NULL,
    [nm_item_complemento]        VARCHAR (60) NULL,
    [ic_tipo_montagem]           CHAR (1)     NULL,
    [cd_item_montagem_grupo]     INT          NULL,
    [ic_texto_padrao_composicao] CHAR (1)     NULL,
    [ic_padrao_montagem]         CHAR (1)     NULL,
    CONSTRAINT [PK_Montagem_Produto_Composicao] PRIMARY KEY CLUSTERED ([cd_montagem_produto] ASC, [cd_item_montagem_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Montagem_Produto_Composicao_Montagem_Produto] FOREIGN KEY ([cd_montagem_produto]) REFERENCES [dbo].[Montagem_Produto] ([cd_montagem_produto])
);

