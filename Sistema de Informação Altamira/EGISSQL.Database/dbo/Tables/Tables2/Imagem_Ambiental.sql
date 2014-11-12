CREATE TABLE [dbo].[Imagem_Ambiental] (
    [cd_imagem_ambiental] INT          NOT NULL,
    [nm_imagem_ambiental] VARCHAR (40) NULL,
    [sg_imagem_ambiental] CHAR (10)    NULL,
    [ds_imagem_ambiental] TEXT         NULL,
    [qt_imagem_ambiental] FLOAT (53)   NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Imagem_Ambiental] PRIMARY KEY CLUSTERED ([cd_imagem_ambiental] ASC) WITH (FILLFACTOR = 90)
);

