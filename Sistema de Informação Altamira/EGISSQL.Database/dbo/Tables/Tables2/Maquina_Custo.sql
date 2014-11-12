CREATE TABLE [dbo].[Maquina_Custo] (
    [cd_maquina]                INT        NOT NULL,
    [vl_base_custo_maquina]     FLOAT (53) NULL,
    [dt_base_custo_maquina]     DATETIME   NULL,
    [vl_simulado_custo_maquina] FLOAT (53) NULL,
    [dt_simulado_custo_maquina] DATETIME   NULL,
    [vl_temp_custo_maquina]     FLOAT (53) NULL,
    [dt_temp_custo_maquina]     DATETIME   NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Maquina_Custo] PRIMARY KEY CLUSTERED ([cd_maquina] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Maquina_Custo_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);

