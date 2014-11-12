CREATE TABLE [dbo].[Complexidade_Ambiental] (
    [cd_complexidade] INT          NOT NULL,
    [nm_complexidade] VARCHAR (40) NULL,
    [sg_complexidade] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Complexidade_Ambiental] PRIMARY KEY CLUSTERED ([cd_complexidade] ASC) WITH (FILLFACTOR = 90)
);

