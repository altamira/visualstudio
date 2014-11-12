CREATE TABLE [dbo].[Embarque_Documento] (
    [cd_embarque]              INT      NOT NULL,
    [cd_tipo_documento_comex]  INT      NOT NULL,
    [cd_tipo_relatorio_idioma] INT      NULL,
    [ds_embarque_documento]    TEXT     NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    [cd_pedido_venda]          INT      NULL,
    CONSTRAINT [PK_Embarque_Documento] PRIMARY KEY CLUSTERED ([cd_embarque] ASC, [cd_tipo_documento_comex] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Embarque_Documento_Tipo_Documento_Comex] FOREIGN KEY ([cd_tipo_documento_comex]) REFERENCES [dbo].[Tipo_Documento_Comex] ([cd_tipo_documento_comex])
);

