CREATE TABLE [dbo].[Custo_Materia_Prima_Historico] (
    [cd_mat_prima]       INT        NOT NULL,
    [dt_custo_mat_prima] DATETIME   NOT NULL,
    [vl_custo_mat_prima] FLOAT (53) NULL,
    [cd_usuario]         INT        NULL,
    [dt_usuario]         DATETIME   NULL,
    CONSTRAINT [PK_Custo_Materia_Prima_Historico] PRIMARY KEY CLUSTERED ([cd_mat_prima] ASC, [dt_custo_mat_prima] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Custo_Materia_Prima_Historico_Materia_Prima] FOREIGN KEY ([cd_mat_prima]) REFERENCES [dbo].[Materia_Prima] ([cd_mat_prima])
);

