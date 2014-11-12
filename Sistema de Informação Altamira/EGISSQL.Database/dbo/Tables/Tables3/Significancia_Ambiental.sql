CREATE TABLE [dbo].[Significancia_Ambiental] (
    [cd_significancia] INT          NOT NULL,
    [nm_significancia] VARCHAR (40) NULL,
    [sg_significancia] CHAR (10)    NULL,
    [ds_significancia] TEXT         NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    [qt_significancia] FLOAT (53)   NULL,
    CONSTRAINT [PK_Significancia_Ambiental] PRIMARY KEY CLUSTERED ([cd_significancia] ASC) WITH (FILLFACTOR = 90)
);

