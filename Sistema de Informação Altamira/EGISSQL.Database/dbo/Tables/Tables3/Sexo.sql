CREATE TABLE [dbo].[Sexo] (
    [cd_sexo]    INT          NOT NULL,
    [nm_sexo]    VARCHAR (30) NOT NULL,
    [sg_sexo]    CHAR (10)    NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_Sexo] PRIMARY KEY CLUSTERED ([cd_sexo] ASC) WITH (FILLFACTOR = 90)
);

