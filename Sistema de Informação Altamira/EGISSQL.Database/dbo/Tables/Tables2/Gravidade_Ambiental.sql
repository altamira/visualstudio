CREATE TABLE [dbo].[Gravidade_Ambiental] (
    [cd_gravidade] INT          NOT NULL,
    [nm_gravidade] VARCHAR (40) NULL,
    [sg_gravidade] CHAR (10)    NULL,
    [ds_gravidade] TEXT         NULL,
    [cd_usuario]   INT          NULL,
    [dt_usuario]   DATETIME     NULL,
    CONSTRAINT [PK_Gravidade_Ambiental] PRIMARY KEY CLUSTERED ([cd_gravidade] ASC) WITH (FILLFACTOR = 90)
);

