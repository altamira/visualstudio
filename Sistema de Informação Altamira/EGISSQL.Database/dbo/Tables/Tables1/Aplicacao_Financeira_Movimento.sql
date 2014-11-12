CREATE TABLE [dbo].[Aplicacao_Financeira_Movimento] (
    [cd_aplicacao_financeira] INT        NOT NULL,
    [dt_movimento_aplicacao]  DATETIME   NOT NULL,
    [pc_movimento_aplicacao]  FLOAT (53) NULL,
    [vl_movimento_aplicacao]  FLOAT (53) NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    [ic_tipo_movimento]       CHAR (3)   NULL,
    CONSTRAINT [PK_Aplicacao_Financeira_Movimento] PRIMARY KEY CLUSTERED ([cd_aplicacao_financeira] ASC, [dt_movimento_aplicacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Aplicacao_Financeira_Movimento_Aplicacao_Financeira] FOREIGN KEY ([cd_aplicacao_financeira]) REFERENCES [dbo].[Aplicacao_Financeira] ([cd_aplicacao_financeira])
);

