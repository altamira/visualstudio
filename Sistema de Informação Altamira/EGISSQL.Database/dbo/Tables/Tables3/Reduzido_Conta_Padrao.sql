CREATE TABLE [dbo].[Reduzido_Conta_Padrao] (
    [cd_plano_padrao]          INT      NOT NULL,
    [cd_conta_reduzido_padrao] INT      NOT NULL,
    [dt_conta_reduzido_padrao] DATETIME NOT NULL,
    [qt_passo_conta_reduzido]  INT      NULL,
    [cd_usuario]               INT      NOT NULL,
    [dt_usuario]               DATETIME NOT NULL,
    CONSTRAINT [PK_Reduzido_conta_padrao] PRIMARY KEY NONCLUSTERED ([cd_plano_padrao] ASC, [cd_conta_reduzido_padrao] ASC) WITH (FILLFACTOR = 90)
);

