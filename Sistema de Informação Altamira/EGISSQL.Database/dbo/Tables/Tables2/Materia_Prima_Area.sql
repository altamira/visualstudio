CREATE TABLE [dbo].[Materia_Prima_Area] (
    [cd_materia_prima_area]     INT          NOT NULL,
    [cd_mat_prima]              INT          NULL,
    [cd_area_placa]             INT          NULL,
    [cd_tipo_lucro]             INT          NULL,
    [nm_obs_materia_prima_area] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Materia_Prima_Area] PRIMARY KEY CLUSTERED ([cd_materia_prima_area] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Materia_Prima_Area_Area_Placa] FOREIGN KEY ([cd_area_placa]) REFERENCES [dbo].[Area_Placa] ([cd_area_placa]),
    CONSTRAINT [FK_Materia_Prima_Area_Materia_Prima] FOREIGN KEY ([cd_mat_prima]) REFERENCES [dbo].[Materia_Prima] ([cd_mat_prima]),
    CONSTRAINT [FK_Materia_Prima_Area_Tipo_Lucro] FOREIGN KEY ([cd_tipo_lucro]) REFERENCES [dbo].[Tipo_Lucro] ([cd_tipo_lucro])
);

