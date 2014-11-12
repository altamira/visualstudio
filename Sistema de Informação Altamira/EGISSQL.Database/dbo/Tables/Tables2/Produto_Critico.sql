CREATE TABLE [dbo].[Produto_Critico] (
    [cd_produto]               INT          NOT NULL,
    [ds_produto_critico]       TEXT         NULL,
    [ic_processo_prod_critico] CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [dt_produto_critico]       DATETIME     NULL,
    [nm_obs_produto_critico]   VARCHAR (40) NULL,
    CONSTRAINT [PK_Produto_Critico] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Critico_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

