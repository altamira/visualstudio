CREATE TABLE [dbo].[idmorc] (
    [idioma]   NVARCHAR (12)  NULL,
    [layout]   NVARCHAR (2)   NULL,
    [variavel] NVARCHAR (100) NULL,
    [traducao] NVARCHAR (100) NULL,
    [idIdmOrc] INT            IDENTITY (1, 1) NOT NULL
);

