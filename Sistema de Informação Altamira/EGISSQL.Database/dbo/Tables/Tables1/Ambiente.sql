CREATE TABLE [dbo].[Ambiente] (
    [cd_ambiente] INT          NOT NULL,
    [nm_ambiente] VARCHAR (40) NULL,
    [sg_ambiente] CHAR (10)    NULL,
    [cd_usuario]  INT          NULL,
    [dt_usuario]  DATETIME     NULL,
    CONSTRAINT [PK_Ambiente] PRIMARY KEY CLUSTERED ([cd_ambiente] ASC) WITH (FILLFACTOR = 90)
);

