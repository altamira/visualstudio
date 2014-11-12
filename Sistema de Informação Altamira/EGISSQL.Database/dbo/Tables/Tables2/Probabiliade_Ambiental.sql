CREATE TABLE [dbo].[Probabiliade_Ambiental] (
    [cd_probabilidade] INT          NOT NULL,
    [nm_probabilidade] VARCHAR (40) NULL,
    [sg_probabilidade] CHAR (10)    NULL,
    [ds_probabilidade] TEXT         NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Probabiliade_Ambiental] PRIMARY KEY CLUSTERED ([cd_probabilidade] ASC) WITH (FILLFACTOR = 90)
);

