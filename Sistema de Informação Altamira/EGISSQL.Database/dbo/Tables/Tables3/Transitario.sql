CREATE TABLE [dbo].[Transitario] (
    [cd_transitario] INT          NOT NULL,
    [nm_transitario] VARCHAR (50) NULL,
    [sg_transitario] CHAR (10)    NULL,
    [cd_usuário]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Transitario] PRIMARY KEY CLUSTERED ([cd_transitario] ASC) WITH (FILLFACTOR = 90)
);

