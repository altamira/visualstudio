CREATE TABLE [dbo].[Fase_Documento] (
    [cd_fase_documento] INT          NOT NULL,
    [nm_fase_documento] VARCHAR (40) NULL,
    [sg_fase_documento] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Fase_Documento] PRIMARY KEY CLUSTERED ([cd_fase_documento] ASC) WITH (FILLFACTOR = 90)
);

