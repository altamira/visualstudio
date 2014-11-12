CREATE TABLE [dbo].[Diametro_Material_Componente] (
    [cd_diametro_material_comp] INT          NOT NULL,
    [nm_diametro_material_comp] VARCHAR (15) NULL,
    [sg_diametro_material_comp] CHAR (10)    NULL,
    [qt_diametro_material_comp] FLOAT (53)   NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Diametro_Material_Componente] PRIMARY KEY CLUSTERED ([cd_diametro_material_comp] ASC) WITH (FILLFACTOR = 90)
);

