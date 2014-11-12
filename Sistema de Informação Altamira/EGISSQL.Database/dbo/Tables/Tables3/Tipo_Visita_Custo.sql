CREATE TABLE [dbo].[Tipo_Visita_Custo] (
    [cd_tipo_visita]           INT        NOT NULL,
    [vl_base_custo_visita]     FLOAT (53) NULL,
    [dt_base_custo_visita]     DATETIME   NULL,
    [vl_simulado_custo_visita] FLOAT (53) NULL,
    [dt_simulado_custo_visita] DATETIME   NULL,
    [vl_temp_custo_visita]     FLOAT (53) NULL,
    [dt_temp_custo_visita]     DATETIME   NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    CONSTRAINT [PK_Tipo_Visita_Custo] PRIMARY KEY CLUSTERED ([cd_tipo_visita] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Visita_Custo_Tipo_Visita] FOREIGN KEY ([cd_tipo_visita]) REFERENCES [dbo].[Tipo_Visita] ([cd_tipo_visita])
);

