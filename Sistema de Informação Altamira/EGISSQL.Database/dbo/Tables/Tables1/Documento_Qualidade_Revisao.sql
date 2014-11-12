CREATE TABLE [dbo].[Documento_Qualidade_Revisao] (
    [cd_revisao_documento]      INT      NOT NULL,
    [cd_documento_qualidade]    INT      NOT NULL,
    [cd_tipo_revisao_documento] INT      NULL,
    [dt_revisao_documento]      DATETIME NULL,
    [ds_revisao_documento]      TEXT     NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    [cd_autor_documento]        INT      NULL,
    CONSTRAINT [PK_Documento_Qualidade_Revisao] PRIMARY KEY CLUSTERED ([cd_revisao_documento] ASC, [cd_documento_qualidade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Qualidade_Revisao_Autor_Documento] FOREIGN KEY ([cd_autor_documento]) REFERENCES [dbo].[Autor_Documento] ([cd_autor])
);

