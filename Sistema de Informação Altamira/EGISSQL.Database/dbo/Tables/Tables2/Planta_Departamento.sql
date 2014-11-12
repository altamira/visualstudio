CREATE TABLE [dbo].[Planta_Departamento] (
    [cd_planta]       INT      NOT NULL,
    [cd_departamento] INT      NOT NULL,
    [cd_usuario]      INT      NULL,
    [dt_usuario]      DATETIME NULL,
    [cd_area]         INT      NULL,
    CONSTRAINT [PK_Planta_Departamento] PRIMARY KEY CLUSTERED ([cd_planta] ASC, [cd_departamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Planta_Departamento_Area] FOREIGN KEY ([cd_area]) REFERENCES [dbo].[Area] ([cd_area]),
    CONSTRAINT [FK_Planta_Departamento_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

