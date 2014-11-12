CREATE TABLE [dbo].[Tipo_Documento_Comex_Idioma] (
    [cd_tipo_documento_comex]  INT          NOT NULL,
    [cd_tipo_idioma]           INT          NOT NULL,
    [nm_tipo_doc_comex_idioma] VARCHAR (40) NOT NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Documento_Comex_Idioma] PRIMARY KEY CLUSTERED ([cd_tipo_documento_comex] ASC, [cd_tipo_idioma] ASC) WITH (FILLFACTOR = 90)
);

