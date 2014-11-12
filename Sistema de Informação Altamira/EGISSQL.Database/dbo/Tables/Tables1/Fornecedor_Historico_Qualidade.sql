CREATE TABLE [dbo].[Fornecedor_Historico_Qualidade] (
    [cd_fornecedor]           INT          NOT NULL,
    [dt_historico_lancamento] DATETIME     NOT NULL,
    [cd_sequencia_historico]  INT          NULL,
    [ds_historico_lancamento] TEXT         NULL,
    [cd_contato_fornecedor]   INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [nm_assunto]              VARCHAR (40) NULL,
    CONSTRAINT [PK_Fornecedor_Historico_Qualidade] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [dt_historico_lancamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fornecedor_Historico_Qualidade_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

