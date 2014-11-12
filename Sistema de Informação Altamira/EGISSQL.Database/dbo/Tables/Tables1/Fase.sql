CREATE TABLE [dbo].[Fase] (
    [cd_fase]    INT          NOT NULL,
    [nm_fase]    VARCHAR (40) NOT NULL,
    [sg_fase]    CHAR (10)    NOT NULL,
    [cd_usuario] INT          NOT NULL,
    [dt_usuario] DATETIME     NOT NULL,
    CONSTRAINT [PK_Fase] PRIMARY KEY CLUSTERED ([cd_fase] ASC) WITH (FILLFACTOR = 90)
);

