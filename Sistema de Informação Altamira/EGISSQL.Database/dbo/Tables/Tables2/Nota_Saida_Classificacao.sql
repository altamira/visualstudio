CREATE TABLE [dbo].[Nota_Saida_Classificacao] (
    [cd_classificacao_fiscal]     INT      NOT NULL,
    [sg_sigla_classificacao_nota] CHAR (5) NULL,
    [cd_usuario]                  INT      NULL,
    [dt_usuario]                  DATETIME NULL,
    [ic_imprime_nota]             CHAR (1) NULL,
    [cd_controle]                 INT      NULL,
    CONSTRAINT [PK_Nota_Saida_Classificacao] PRIMARY KEY CLUSTERED ([cd_classificacao_fiscal] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Nota_Saida_Classificacao_Classificacao_Fiscal] FOREIGN KEY ([cd_classificacao_fiscal]) REFERENCES [dbo].[Classificacao_Fiscal] ([cd_classificacao_fiscal])
);

