CREATE TABLE [dbo].[Editora] (
    [cd_editora]          INT          NOT NULL,
    [nm_editora]          VARCHAR (40) NULL,
    [sg_editora]          CHAR (10)    NULL,
    [nm_fantasia_editora] VARCHAR (15) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Editora] PRIMARY KEY CLUSTERED ([cd_editora] ASC) WITH (FILLFACTOR = 90)
);

