CREATE TABLE [dbo].[Liminar] (
    [cd_liminar] INT          NOT NULL,
    [nm_liminar] VARCHAR (40) NULL,
    [sg_liminar] CHAR (10)    NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_Liminar] PRIMARY KEY CLUSTERED ([cd_liminar] ASC) WITH (FILLFACTOR = 90)
);

