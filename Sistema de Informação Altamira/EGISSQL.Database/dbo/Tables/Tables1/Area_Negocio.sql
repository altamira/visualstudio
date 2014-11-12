CREATE TABLE [dbo].[Area_Negocio] (
    [cd_area_negocio] INT          NOT NULL,
    [nm_area_negocio] VARCHAR (40) NULL,
    [sg_area_negocio] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    [ds_area_negocio] TEXT         NULL,
    CONSTRAINT [PK_Area_Negocio] PRIMARY KEY CLUSTERED ([cd_area_negocio] ASC) WITH (FILLFACTOR = 90)
);

