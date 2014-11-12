CREATE TABLE [dbo].[Comarca] (
    [cd_comarca] INT          NOT NULL,
    [nm_comarca] VARCHAR (40) NULL,
    [sg_comarca] CHAR (10)    NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_Comarca] PRIMARY KEY CLUSTERED ([cd_comarca] ASC) WITH (FILLFACTOR = 90)
);

