CREATE TABLE [dbo].[Grupo_Produto_Contabilizacao] (
    [cd_grupo_produto]         INT          NOT NULL,
    [cd_lancamento_padrao]     INT          NOT NULL,
    [cd_tipo_mercado]          INT          NOT NULL,
    [cd_tipo_contabilizacao]   INT          NOT NULL,
    [nm_obs_grupo_prod_contab] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Produto_Contabilizacao] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_lancamento_padrao] ASC, [cd_tipo_mercado] ASC, [cd_tipo_contabilizacao] ASC) WITH (FILLFACTOR = 90)
);

