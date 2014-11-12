CREATE TABLE [dbo].[Area_Produto] (
    [cd_area_produto] INT          NOT NULL,
    [nm_area_produto] VARCHAR (40) NULL,
    [sg_area_produto] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Area_Produto] PRIMARY KEY CLUSTERED ([cd_area_produto] ASC) WITH (FILLFACTOR = 90)
);

