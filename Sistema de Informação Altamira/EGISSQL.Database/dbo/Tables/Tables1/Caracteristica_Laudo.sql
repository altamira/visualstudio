CREATE TABLE [dbo].[Caracteristica_Laudo] (
    [cd_caracteristica_laudo] INT           NOT NULL,
    [nm_caracteristica_laudo] VARCHAR (100) NULL,
    [sg_caracteristica_laudo] CHAR (10)     NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    CONSTRAINT [PK_Caracteristica_Laudo] PRIMARY KEY CLUSTERED ([cd_caracteristica_laudo] ASC) WITH (FILLFACTOR = 90)
);

