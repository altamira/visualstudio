CREATE TABLE [dbo].[Materia_Prima_Custo] (
    [cd_mat_prima]                INT        NOT NULL,
    [vl_base_custo_mat_prima]     FLOAT (53) NULL,
    [dt_base_custo_mat_prima]     DATETIME   NULL,
    [vl_simulado_custo_mat_prima] FLOAT (53) NULL,
    [dt_simulado_custo_mat_prima] DATETIME   NULL,
    [vl_temp_custo_mat_prima]     FLOAT (53) NULL,
    [dt_temp_custo_mat_prima]     DATETIME   NULL,
    [dt_usuario]                  DATETIME   NULL,
    [cd_usuario]                  INT        NULL,
    CONSTRAINT [PK_Materia_Prima_Custo] PRIMARY KEY CLUSTERED ([cd_mat_prima] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Materia_Prima_Custo_Materia_Prima] FOREIGN KEY ([cd_mat_prima]) REFERENCES [dbo].[Materia_Prima] ([cd_mat_prima])
);

