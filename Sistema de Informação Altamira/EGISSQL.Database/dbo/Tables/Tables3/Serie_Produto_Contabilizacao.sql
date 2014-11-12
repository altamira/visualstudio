CREATE TABLE [dbo].[Serie_Produto_Contabilizacao] (
    [cd_serie_produto]         INT          NOT NULL,
    [cd_lancamento_padrao]     INT          NOT NULL,
    [cd_tipo_mercado]          INT          NOT NULL,
    [cd_tipo_contabilizacao]   INT          NOT NULL,
    [nm_obs_serie_prod_contab] VARCHAR (40) NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    CONSTRAINT [PK_Serie_Produto_Contabilizacao] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC, [cd_lancamento_padrao] ASC, [cd_tipo_mercado] ASC, [cd_tipo_contabilizacao] ASC) WITH (FILLFACTOR = 90)
);

