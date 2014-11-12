CREATE TABLE [dbo].[Produto_Producao] (
    [cd_produto]              INT      NOT NULL,
    [cd_processo_padrao]      INT      NOT NULL,
    [ds_produto_producao]     TEXT     NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    [ic_custo_padrao_produto] CHAR (1) NULL,
    CONSTRAINT [PK_Produto_Producao] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_processo_padrao] ASC) WITH (FILLFACTOR = 90)
);

