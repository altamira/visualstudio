CREATE TABLE [dbo].[Tipo_Documento_Comex] (
    [cd_tipo_documento_comex] INT          NOT NULL,
    [nm_tipo_documento_comex] VARCHAR (40) NOT NULL,
    [sg_tipo_documento_comex] CHAR (10)    NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    [ic_tipo_documento_comex] CHAR (1)     NULL,
    [cd_documento_relatorio]  INT          NULL,
    [cd_classe_relatorio]     INT          NULL,
    [ic_pad_importacao]       CHAR (1)     NULL,
    [ic_pad_exportacao]       CHAR (1)     NULL,
    [ic_ativo_documento]      CHAR (1)     NULL,
    [cd_idioma]               INT          NULL,
    CONSTRAINT [PK_Tipo_Documento_Comex] PRIMARY KEY CLUSTERED ([cd_tipo_documento_comex] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Documento_Comex_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

