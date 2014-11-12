CREATE TABLE [dbo].[Meio_Campanha] (
    [cd_meio_campanha] INT          NOT NULL,
    [nm_meio_campanha] VARCHAR (30) NOT NULL,
    [sg_meio_campanha] VARCHAR (10) NOT NULL,
    [cd_usuario]       INT          NOT NULL,
    [dt_usuario]       DATETIME     NOT NULL,
    CONSTRAINT [PK_Meio_campanha] PRIMARY KEY NONCLUSTERED ([cd_meio_campanha] ASC) WITH (FILLFACTOR = 90)
);

