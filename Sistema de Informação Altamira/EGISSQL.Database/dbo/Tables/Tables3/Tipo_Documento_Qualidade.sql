CREATE TABLE [dbo].[Tipo_Documento_Qualidade] (
    [cd_tipo_documento] INT          NOT NULL,
    [nm_tipo_documento] VARCHAR (40) NULL,
    [sg_tipo_documento] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Documento_Qualidade] PRIMARY KEY CLUSTERED ([cd_tipo_documento] ASC) WITH (FILLFACTOR = 90)
);

