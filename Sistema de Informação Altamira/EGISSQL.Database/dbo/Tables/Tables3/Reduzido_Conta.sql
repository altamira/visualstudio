CREATE TABLE [dbo].[Reduzido_Conta] (
    [cd_empresa]              INT        NOT NULL,
    [cd_conta_reduzido]       INT        NOT NULL,
    [dt_conta_reduzido]       DATETIME   NOT NULL,
    [qt_passo_conta_reduzido] FLOAT (53) NULL,
    [cd_usuario]              INT        NOT NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Reduzido_Conta] PRIMARY KEY NONCLUSTERED ([cd_empresa] ASC, [cd_conta_reduzido] ASC) WITH (FILLFACTOR = 90)
);

