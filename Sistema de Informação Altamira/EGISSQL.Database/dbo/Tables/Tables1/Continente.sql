CREATE TABLE [dbo].[Continente] (
    [cd_continente] INT          NOT NULL,
    [nm_continente] VARCHAR (60) NULL,
    [sg_continente] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Continente] PRIMARY KEY CLUSTERED ([cd_continente] ASC) WITH (FILLFACTOR = 90)
);

