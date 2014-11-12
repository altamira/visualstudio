CREATE TABLE [dbo].[Origem_Documento] (
    [cd_origem_documento] INT          NOT NULL,
    [nm_origem_documento] VARCHAR (40) NULL,
    [sg_origem_documento] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Origem_Documento] PRIMARY KEY CLUSTERED ([cd_origem_documento] ASC) WITH (FILLFACTOR = 90)
);

