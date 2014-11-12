CREATE TABLE [dbo].[Documento_Texto_Padrao] (
    [cd_documento_texto_padrao] INT          NOT NULL,
    [nm_documento_texto_padrao] VARCHAR (40) NULL,
    [sg_documento_texto_padrao] CHAR (10)    NULL,
    [ds_documento_texto_padrao] TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Documento_Texto_Padrao] PRIMARY KEY CLUSTERED ([cd_documento_texto_padrao] ASC) WITH (FILLFACTOR = 90)
);

