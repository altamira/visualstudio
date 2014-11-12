CREATE TABLE [dbo].[Movimento_Comissao] (
    [cd_parametro_comissao]    INT          NOT NULL,
    [cd_vendedor]              INT          NOT NULL,
    [cd_regiao_venda]          INT          NOT NULL,
    [cd_ocorrencia_comissao]   INT          NOT NULL,
    [cd_item_ocorrencia_comis] INT          NOT NULL,
    [nm_lancamento_comissao]   VARCHAR (50) NULL,
    [vl_lancamento_comissao]   FLOAT (53)   NULL,
    [ic_tipo_lanc_contabil]    CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Movimento_Comissao] PRIMARY KEY CLUSTERED ([cd_parametro_comissao] ASC, [cd_vendedor] ASC, [cd_regiao_venda] ASC, [cd_ocorrencia_comissao] ASC, [cd_item_ocorrencia_comis] ASC) WITH (FILLFACTOR = 90)
);

