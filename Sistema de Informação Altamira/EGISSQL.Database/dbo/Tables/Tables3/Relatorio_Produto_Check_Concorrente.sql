CREATE TABLE [dbo].[Relatorio_Produto_Check_Concorrente] (
    [cd_produto_check]      INT      NOT NULL,
    [cd_produto_check_list] INT      NOT NULL,
    [cd_concorrente]        INT      NULL,
    [cd_tipo_fornecimento]  INT      NULL,
    [cd_tipo_participacao]  INT      NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Relatorio_Produto_Check_Concorrente] PRIMARY KEY CLUSTERED ([cd_produto_check] ASC, [cd_produto_check_list] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Relatorio_Produto_Check_Concorrente_Concorrente] FOREIGN KEY ([cd_concorrente]) REFERENCES [dbo].[Concorrente] ([cd_concorrente]),
    CONSTRAINT [FK_Relatorio_Produto_Check_Concorrente_Tipo_Fornecimento] FOREIGN KEY ([cd_tipo_fornecimento]) REFERENCES [dbo].[Tipo_Fornecimento] ([cd_tipo_fornecimento]),
    CONSTRAINT [FK_Relatorio_Produto_Check_Concorrente_Tipo_Participacao] FOREIGN KEY ([cd_tipo_participacao]) REFERENCES [dbo].[Tipo_Participacao] ([cd_tipo_participacao])
);

