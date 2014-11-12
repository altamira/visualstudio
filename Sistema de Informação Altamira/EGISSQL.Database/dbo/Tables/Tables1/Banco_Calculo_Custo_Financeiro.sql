CREATE TABLE [dbo].[Banco_Calculo_Custo_Financeiro] (
    [cd_banco]                INT      NOT NULL,
    [cd_calculo_custo_fin]    INT      NOT NULL,
    [cd_banco_calc_custo_fin] INT      NOT NULL,
    [ic_padrao]               CHAR (1) NULL,
    CONSTRAINT [PK_Banco_Calculo_Custo_Financeiro] PRIMARY KEY CLUSTERED ([cd_banco_calc_custo_fin] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Banco_Calculo_Custo_Financeiro_Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco]),
    CONSTRAINT [FK_Banco_Calculo_Custo_Financeiro_Calculo_Custo_Financeiro] FOREIGN KEY ([cd_calculo_custo_fin]) REFERENCES [dbo].[Calculo_Custo_Financeiro] ([cd_calculo_custo_fin])
);

