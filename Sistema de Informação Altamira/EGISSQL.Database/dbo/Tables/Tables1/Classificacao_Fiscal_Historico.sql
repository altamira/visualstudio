CREATE TABLE [dbo].[Classificacao_Fiscal_Historico] (
    [dt_historico_classifica] DATETIME     NOT NULL,
    [cd_produto]              INT          NOT NULL,
    [cd_classificacao_fiscal] INT          NULL,
    [nm_historico_classifica] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Classificacao_Fiscal_Historico] PRIMARY KEY CLUSTERED ([dt_historico_classifica] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Classificacao_Fiscal_Historico_Classificacao_Fiscal] FOREIGN KEY ([cd_classificacao_fiscal]) REFERENCES [dbo].[Classificacao_Fiscal] ([cd_classificacao_fiscal])
);

