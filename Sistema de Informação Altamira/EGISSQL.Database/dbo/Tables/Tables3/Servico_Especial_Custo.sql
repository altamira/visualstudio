CREATE TABLE [dbo].[Servico_Especial_Custo] (
    [cd_servico_especial]       INT        NOT NULL,
    [vl_base_custo_servico]     FLOAT (53) NULL,
    [dt_base_custo_servico]     DATETIME   NULL,
    [vl_simulado_custo_servico] FLOAT (53) NULL,
    [dt_simulado_custo_servico] DATETIME   NULL,
    [vl_temp_custo_servico]     FLOAT (53) NULL,
    [dt_temp_custo_servico]     DATETIME   NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Servico_Especial_Custo] PRIMARY KEY CLUSTERED ([cd_servico_especial] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Servico_Especial_Custo_Servico_Especial] FOREIGN KEY ([cd_servico_especial]) REFERENCES [dbo].[Servico_Especial] ([cd_servico_especial])
);

