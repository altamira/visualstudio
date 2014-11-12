CREATE TABLE [dbo].[Resumo_Comissao] (
    [cd_parametro_comissao]    INT        NOT NULL,
    [cd_vendedor]              INT        NOT NULL,
    [cd_regiao_venda]          INT        NOT NULL,
    [cd_categoria_produto]     INT        NOT NULL,
    [vl_comissao]              FLOAT (53) NULL,
    [vl_comissao_sem_desconto] FLOAT (53) NULL,
    [pc_desconto]              FLOAT (53) NULL,
    [dt_calculo]               DATETIME   NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    CONSTRAINT [PK_Resumo_Comissao] PRIMARY KEY CLUSTERED ([cd_parametro_comissao] ASC, [cd_vendedor] ASC, [cd_regiao_venda] ASC, [cd_categoria_produto] ASC) WITH (FILLFACTOR = 90)
);

