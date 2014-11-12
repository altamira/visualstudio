CREATE TABLE [dbo].[Causa_Morte] (
    [cd_causa_morte] INT          NOT NULL,
    [nm_causa_morte] VARCHAR (80) NOT NULL,
    [sg_causa_morte] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Causa_Morte] PRIMARY KEY CLUSTERED ([cd_causa_morte] ASC) WITH (FILLFACTOR = 90)
);

