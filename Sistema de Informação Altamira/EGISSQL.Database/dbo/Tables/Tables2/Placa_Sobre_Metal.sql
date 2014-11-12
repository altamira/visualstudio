CREATE TABLE [dbo].[Placa_Sobre_Metal] (
    [cd_placa]            INT        NULL,
    [qt_esp_sobre_metal]  FLOAT (53) NULL,
    [qt_larg_sobre_metal] FLOAT (53) NULL,
    [qt_comp_sobre_metal] FLOAT (53) NULL,
    [cd_material_prima]   INT        NULL,
    [cd_usuario]          INT        NULL,
    [dt_usuario]          DATETIME   NULL,
    CONSTRAINT [FK_Placa_Sobre_Metal_Materia_Prima] FOREIGN KEY ([cd_material_prima]) REFERENCES [dbo].[Materia_Prima] ([cd_mat_prima]),
    CONSTRAINT [FK_Placa_Sobre_Metal_Placa] FOREIGN KEY ([cd_placa]) REFERENCES [dbo].[Placa] ([cd_placa])
);

