CREATE TABLE [dbo].[Bloco_Ossario] (
    [cd_bloco_ossario] INT          NOT NULL,
    [cd_cemiterio]     INT          NULL,
    [nm_bloco_ossario] VARCHAR (20) NULL,
    [sg_bloco_ossario] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Bloco_Ossario] PRIMARY KEY CLUSTERED ([cd_bloco_ossario] ASC) WITH (FILLFACTOR = 90)
);

