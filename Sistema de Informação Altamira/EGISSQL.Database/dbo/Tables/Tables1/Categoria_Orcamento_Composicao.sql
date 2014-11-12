CREATE TABLE [dbo].[Categoria_Orcamento_Composicao] (
    [cd_categoria_orcamento]     INT        NOT NULL,
    [vl_categoria_orcamento]     FLOAT (53) NULL,
    [cd_usuario]                 INT        NULL,
    [dt_usuario]                 DATETIME   NULL,
    [ic_base_dia_util_categoria] CHAR (1)   NULL,
    [ic_producao_diaria]         CHAR (1)   NULL,
    [ic_producao_orcamento]      CHAR (1)   NULL,
    [ic_valor_total]             CHAR (1)   NULL,
    [ic_peso_orcamento]          CHAR (1)   NULL,
    CONSTRAINT [PK_Categoria_Orcamento_Composicao] PRIMARY KEY CLUSTERED ([cd_categoria_orcamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Categoria_Orcamento_Composicao_Categoria_Orcamento] FOREIGN KEY ([cd_categoria_orcamento]) REFERENCES [dbo].[Categoria_Orcamento] ([cd_categoria_orcamento])
);

