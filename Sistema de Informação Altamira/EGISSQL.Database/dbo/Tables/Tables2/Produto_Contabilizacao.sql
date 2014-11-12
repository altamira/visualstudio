CREATE TABLE [dbo].[Produto_Contabilizacao] (
    [cd_produto]                INT          NOT NULL,
    [cd_tipo_mercado]           INT          NOT NULL,
    [cd_tipo_contabilizacao]    INT          NULL,
    [cd_lancamento_padrao]      INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_lanc_padrao]            INT          NULL,
    [nm_obs_prod_conta]         VARCHAR (40) NULL,
    [cd_grupo_produto]          INT          NULL,
    [cd_produto_contabilizacao] INT          NULL,
    [nm_obs_prod_contab]        VARCHAR (40) NULL
);

