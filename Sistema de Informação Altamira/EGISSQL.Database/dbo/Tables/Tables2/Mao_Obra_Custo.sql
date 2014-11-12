CREATE TABLE [dbo].[Mao_Obra_Custo] (
    [cd_mao_obra]                INT        NOT NULL,
    [vl_base_custo_mao_obra]     FLOAT (53) NULL,
    [dt_base_custo_mao_obra]     DATETIME   NULL,
    [vl_simulado_custo_mao_obra] FLOAT (53) NULL,
    [dt_simulado_custo_mao_obra] DATETIME   NULL,
    [vl_temp_custo_mao_obra]     FLOAT (53) NULL,
    [dt_temp_custo_mao_obra]     DATETIME   NULL,
    [cd_usuario]                 INT        NULL,
    [dt_usuario]                 DATETIME   NULL,
    CONSTRAINT [PK_Mao_Obra_Custo] PRIMARY KEY CLUSTERED ([cd_mao_obra] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Mao_Obra_Custo_Mao_Obra] FOREIGN KEY ([cd_mao_obra]) REFERENCES [dbo].[Mao_Obra] ([cd_mao_obra])
);

