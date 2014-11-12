CREATE TABLE [dbo].[Montagem] (
    [cd_montagem] INT          NOT NULL,
    [nm_montagem] VARCHAR (30) NOT NULL,
    [sg_montagem] CHAR (10)    NULL,
    [qt_montagem] FLOAT (53)   NULL,
    [cd_usuario]  INT          NULL,
    [dt_usuario]  DATETIME     NULL,
    CONSTRAINT [PK_Montagem] PRIMARY KEY CLUSTERED ([cd_montagem] ASC) WITH (FILLFACTOR = 90)
);

