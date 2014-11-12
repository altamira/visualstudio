CREATE TABLE [dbo].[Aplicacao] (
    [cd_aplicacao] INT          NOT NULL,
    [nm_aplicacao] VARCHAR (30) NOT NULL,
    [sg_aplicacao] CHAR (10)    NOT NULL,
    [cd_usuario]   INT          NOT NULL,
    [dt_usuario]   DATETIME     NOT NULL,
    CONSTRAINT [PK_Aplicacao] PRIMARY KEY CLUSTERED ([cd_aplicacao] ASC) WITH (FILLFACTOR = 90)
);

