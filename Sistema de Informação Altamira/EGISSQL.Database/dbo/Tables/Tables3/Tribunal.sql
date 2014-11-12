CREATE TABLE [dbo].[Tribunal] (
    [cd_tribunal] INT          NOT NULL,
    [nm_tribunal] VARCHAR (60) NULL,
    [sg_tribunal] CHAR (10)    NULL,
    [ds_tribunal] TEXT         NULL,
    [cd_usuario]  INT          NULL,
    [dt_usuario]  DATETIME     NULL,
    CONSTRAINT [PK_Tribunal] PRIMARY KEY CLUSTERED ([cd_tribunal] ASC) WITH (FILLFACTOR = 90)
);

