CREATE TABLE [dbo].[Oleo_Refrigerante] (
    [cd_oleo_refrigerante] INT          NOT NULL,
    [nm_oleo_refrigerante] VARCHAR (30) NOT NULL,
    [sg_oleo_refrigerante] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Oleo_Refrigerante] PRIMARY KEY CLUSTERED ([cd_oleo_refrigerante] ASC) WITH (FILLFACTOR = 90)
);

