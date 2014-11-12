CREATE TABLE [dbo].[Produto_Cliente_Historico] (
    [cd_historico]         INT        NOT NULL,
    [cd_cliente]           INT        NOT NULL,
    [cd_produto]           INT        NOT NULL,
    [cd_tipo_reajuste]     INT        NULL,
    [cd_tipo_tabela_preco] INT        NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    [cd_motivo_reajuste]   INT        NULL,
    [dt_historico]         DATETIME   NULL,
    [vl_historico]         FLOAT (53) NULL,
    CONSTRAINT [PK_Produto_Cliente_Historico] PRIMARY KEY CLUSTERED ([cd_historico] ASC) WITH (FILLFACTOR = 90)
);

