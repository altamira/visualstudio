CREATE TABLE [dbo].[Origem_Bem] (
    [cd_origem_bem] INT          NOT NULL,
    [nm_origem_bem] VARCHAR (40) NULL,
    [sg_origem_bem] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Origem_Bem] PRIMARY KEY CLUSTERED ([cd_origem_bem] ASC) WITH (FILLFACTOR = 90)
);

