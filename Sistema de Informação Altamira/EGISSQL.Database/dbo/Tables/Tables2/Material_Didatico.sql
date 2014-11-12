CREATE TABLE [dbo].[Material_Didatico] (
    [cd_material_didatico] INT          NOT NULL,
    [nm_material_didatico] VARCHAR (40) NULL,
    [sg_material_didatico] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Material_Didatico] PRIMARY KEY CLUSTERED ([cd_material_didatico] ASC) WITH (FILLFACTOR = 90)
);

