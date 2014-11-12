CREATE TABLE [dbo].[Natureza_Processo] (
    [cd_natureza_processo] INT          NOT NULL,
    [nm_natureza_processo] VARCHAR (40) NULL,
    [sg_natureza_processo] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Natureza_Processo] PRIMARY KEY CLUSTERED ([cd_natureza_processo] ASC) WITH (FILLFACTOR = 90)
);

