CREATE TABLE [dbo].[Curso_Material_Didatico] (
    [cd_curso]                 INT          NOT NULL,
    [cd_material_didatico]     INT          NOT NULL,
    [qt_material_didatico]     FLOAT (53)   NULL,
    [nm_obs_material_didatico] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Curso_Material_Didatico] PRIMARY KEY CLUSTERED ([cd_curso] ASC, [cd_material_didatico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Curso_Material_Didatico_Material_Didatico] FOREIGN KEY ([cd_material_didatico]) REFERENCES [dbo].[Material_Didatico] ([cd_material_didatico])
);

