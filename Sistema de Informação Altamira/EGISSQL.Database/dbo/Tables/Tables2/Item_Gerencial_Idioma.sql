CREATE TABLE [dbo].[Item_Gerencial_Idioma] (
    [cd_grupo_gerencial]       INT          NOT NULL,
    [cd_item_gerencial]        INT          NOT NULL,
    [cd_idioma]                INT          NOT NULL,
    [nm_item_gerencial_idioma] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Item_Gerencial_Idioma] PRIMARY KEY CLUSTERED ([cd_grupo_gerencial] ASC, [cd_item_gerencial] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

