CREATE TABLE [dbo].[Material_Plastico] (
    [cd_material_plastico] INT          NOT NULL,
    [nm_material_plastico] VARCHAR (30) NOT NULL,
    [sg_material_plastico] CHAR (10)    NOT NULL,
    [cd_fluidez_material]  INT          NOT NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Material_Plastico] PRIMARY KEY NONCLUSTERED ([cd_material_plastico] ASC) WITH (FILLFACTOR = 90)
);

