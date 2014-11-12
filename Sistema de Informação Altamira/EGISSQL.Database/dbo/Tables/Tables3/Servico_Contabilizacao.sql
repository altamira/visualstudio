CREATE TABLE [dbo].[Servico_Contabilizacao] (
    [cd_grupo_produto]        INT          NOT NULL,
    [cd_categoria_produto]    INT          NOT NULL,
    [cd_lancamento_padrao]    INT          NULL,
    [nm_obs_servico_contabil] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_tipo_contabilizacao]  INT          NULL,
    [cd_tipo_mercado]         INT          NULL,
    CONSTRAINT [PK_Servico_Contabilizacao] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_categoria_produto] ASC) WITH (FILLFACTOR = 90)
);

