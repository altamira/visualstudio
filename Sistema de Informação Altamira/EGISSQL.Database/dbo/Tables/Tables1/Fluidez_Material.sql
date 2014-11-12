CREATE TABLE [dbo].[Fluidez_Material] (
    [cd_fluidez_material] INT          NOT NULL,
    [nm_fluidez_material] VARCHAR (30) NOT NULL,
    [sg_fluidez_material] CHAR (5)     NOT NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Fluidez_Material] PRIMARY KEY NONCLUSTERED ([cd_fluidez_material] ASC) WITH (FILLFACTOR = 90)
);

