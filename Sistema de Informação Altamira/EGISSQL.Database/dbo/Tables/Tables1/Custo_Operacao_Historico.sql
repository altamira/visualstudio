CREATE TABLE [dbo].[Custo_Operacao_Historico] (
    [cd_operacao]       INT        NOT NULL,
    [dt_custo_operacao] DATETIME   NOT NULL,
    [vl_custo_operacao] FLOAT (53) NULL,
    [cd_usuario]        INT        NULL,
    [dt_usuario]        DATETIME   NULL,
    CONSTRAINT [PK_Custo_Operacao_Historico] PRIMARY KEY CLUSTERED ([cd_operacao] ASC, [dt_custo_operacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Custo_Operacao_Historico_Operacao] FOREIGN KEY ([cd_operacao]) REFERENCES [dbo].[Operacao] ([cd_operacao])
);

