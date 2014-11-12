CREATE TABLE [dbo].[Causa_Obito] (
    [cd_causa_obito] INT          NOT NULL,
    [nm_causa_obito] VARCHAR (40) NULL,
    [sg_causa_obito] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Causa_Obito] PRIMARY KEY CLUSTERED ([cd_causa_obito] ASC) WITH (FILLFACTOR = 90)
);

