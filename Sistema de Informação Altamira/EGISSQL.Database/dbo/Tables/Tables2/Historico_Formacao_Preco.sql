CREATE TABLE [dbo].[Historico_Formacao_Preco] (
    [dt_formacao_preco]      DATETIME     NOT NULL,
    [cd_grupo_produto]       INT          NOT NULL,
    [cd_produto]             INT          NOT NULL,
    [vl_total_mat_prima]     FLOAT (53)   NOT NULL,
    [vl_total_mao_obra]      FLOAT (53)   NOT NULL,
    [vl_total_servico]       FLOAT (53)   NOT NULL,
    [vl_total_markup]        FLOAT (53)   NOT NULL,
    [pc_lucro_historico]     FLOAT (53)   NOT NULL,
    [vl_total_custo]         FLOAT (53)   NOT NULL,
    [vl_total_venda]         FLOAT (53)   NOT NULL,
    [ds_hist_formacao_preco] VARCHAR (40) NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Historico_Formacao_Preco] PRIMARY KEY CLUSTERED ([dt_formacao_preco] ASC, [cd_grupo_produto] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90)
);

