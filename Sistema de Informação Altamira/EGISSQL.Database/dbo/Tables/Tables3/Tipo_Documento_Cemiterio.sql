CREATE TABLE [dbo].[Tipo_Documento_Cemiterio] (
    [cd_tipo_doc_cemiterio] INT          NOT NULL,
    [nm_tipo_doc_cemiterio] VARCHAR (25) NULL,
    [sg_tipo_doc_cemiterio] CHAR (10)    NULL,
    [ds_tipo_documento]     TEXT         NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Documento_Cemiterio] PRIMARY KEY CLUSTERED ([cd_tipo_doc_cemiterio] ASC) WITH (FILLFACTOR = 90)
);

