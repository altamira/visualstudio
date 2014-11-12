CREATE TABLE [dbo].[Lote_Produto] (
    [cd_lote_produto]          INT          NOT NULL,
    [nm_lote_produto]          VARCHAR (40) NOT NULL,
    [nm_ref_lote_produto]      VARCHAR (25) NULL,
    [ic_status_lote_produto]   CHAR (1)     NULL,
    [dt_entrada_lote_produto]  DATETIME     NULL,
    [dt_inicial_lote_produto]  DATETIME     NULL,
    [dt_final_lote_produto]    DATETIME     NULL,
    [ic_inspecao_lote_produto] CHAR (1)     NULL,
    [dt_inspecao_lote_produto] DATETIME     NULL,
    [ic_rastro_lote_produto]   CHAR (1)     NULL,
    [cd_pais]                  INT          NULL,
    [cd_processo]              INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_obs_lote_produto]      VARCHAR (40) NULL,
    [dt_saida_lote_produto]    DATETIME     NULL,
    [cd_fornecedor]            INT          NULL,
    [ic_estoque_lote_produto]  CHAR (1)     NULL,
    [cd_loja]                  INT          NULL,
    CONSTRAINT [PK_Lote_Produto] PRIMARY KEY CLUSTERED ([cd_lote_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Lote_Produto_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

