CREATE TABLE [dbo].[Operacao_Custo] (
    [cd_operacao]                INT        NOT NULL,
    [vl_base_custo_operacao]     FLOAT (53) NULL,
    [dt_base_custo_operacao]     DATETIME   NULL,
    [vl_simulado_custo_operacao] FLOAT (53) NULL,
    [dt_simulado_custo_operacao] DATETIME   NULL,
    [vl_temp_custo_operacao]     FLOAT (53) NULL,
    [dt_temp_custo_operacao]     DATETIME   NULL,
    [cd_usuario]                 INT        NULL,
    [dt_usuario]                 DATETIME   NULL,
    CONSTRAINT [PK_Operacao_Custo] PRIMARY KEY CLUSTERED ([cd_operacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Operacao_Custo_Operacao] FOREIGN KEY ([cd_operacao]) REFERENCES [dbo].[Operacao] ([cd_operacao])
);

