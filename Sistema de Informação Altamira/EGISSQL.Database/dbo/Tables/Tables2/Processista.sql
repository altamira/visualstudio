CREATE TABLE [dbo].[Processista] (
    [cd_processista]          INT          NOT NULL,
    [nm_processista]          VARCHAR (40) NOT NULL,
    [nm_fantasia_processista] VARCHAR (15) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Processista] PRIMARY KEY CLUSTERED ([cd_processista] ASC) WITH (FILLFACTOR = 90)
);

