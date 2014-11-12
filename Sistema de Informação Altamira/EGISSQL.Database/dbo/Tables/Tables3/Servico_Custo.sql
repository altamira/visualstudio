CREATE TABLE [dbo].[Servico_Custo] (
    [cd_servico]                INT        NOT NULL,
    [vl_base_custo_servico]     FLOAT (53) NULL,
    [dt_base_custo_servico]     DATETIME   NULL,
    [vl_simulado_custo_servico] FLOAT (53) NULL,
    [dt_simulado_custo_servico] DATETIME   NULL,
    [vl_temp_custo_servico]     FLOAT (53) NULL,
    [dt_temp_custo_servico]     DATETIME   NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Servico_Custo] PRIMARY KEY CLUSTERED ([cd_servico] ASC) WITH (FILLFACTOR = 90)
);

