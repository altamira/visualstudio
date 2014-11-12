CREATE TABLE [dbo].[Documento] (
    [cd_documento_fiscal] INT          NOT NULL,
    [nm_documento_fiscal] VARCHAR (40) NOT NULL,
    [sg_documento_fiscal] CHAR (5)     NOT NULL,
    [cd_modelo_documento] INT          NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Documento] PRIMARY KEY NONCLUSTERED ([cd_documento_fiscal] ASC) WITH (FILLFACTOR = 90)
);

