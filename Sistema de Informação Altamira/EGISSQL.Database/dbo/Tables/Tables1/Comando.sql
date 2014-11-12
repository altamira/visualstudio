CREATE TABLE [dbo].[Comando] (
    [cd_comando] INT          NOT NULL,
    [nm_comando] VARCHAR (40) NULL,
    [sg_comando] CHAR (15)    NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_Comando] PRIMARY KEY CLUSTERED ([cd_comando] ASC) WITH (FILLFACTOR = 90)
);

