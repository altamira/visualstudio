CREATE TABLE [dbo].[Parametro_Extrato_Banco] (
    [cd_empresa]              INT      NOT NULL,
    [cd_plano_financeiro]     INT      NULL,
    [cd_historico_financeiro] INT      NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    [cd_banco]                INT      NULL,
    [cd_conta_banco]          INT      NULL,
    CONSTRAINT [PK_Parametro_Extrato_Banco] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Extrato_Banco_Historico_Financeiro] FOREIGN KEY ([cd_historico_financeiro]) REFERENCES [dbo].[Historico_Financeiro] ([cd_historico_financeiro])
);

