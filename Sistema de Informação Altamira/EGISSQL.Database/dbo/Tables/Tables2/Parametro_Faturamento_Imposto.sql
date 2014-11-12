CREATE TABLE [dbo].[Parametro_Faturamento_Imposto] (
    [cd_empresa]           INT      NOT NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    [cd_imposto_simples]   INT      NULL,
    [cd_situacao_operacao] INT      NULL,
    CONSTRAINT [PK_Parametro_Faturamento_Imposto] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Faturamento_Imposto_Imposto_Simples] FOREIGN KEY ([cd_imposto_simples]) REFERENCES [dbo].[Imposto_Simples] ([cd_imposto_simples]),
    CONSTRAINT [FK_Parametro_Faturamento_Imposto_Situacao_Operacao_Simples] FOREIGN KEY ([cd_situacao_operacao]) REFERENCES [dbo].[Situacao_Operacao_Simples] ([cd_situacao_operacao])
);

