CREATE TABLE [dbo].[Embarque_Importacao_Documento] (
    [cd_embarque]              INT      NOT NULL,
    [cd_tipo_documento_comex]  INT      NOT NULL,
    [cd_tipo_relatorio_idioma] INT      NOT NULL,
    [ds_embarque_documento]    TEXT     NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    [cd_pedido_importacao]     INT      NOT NULL,
    CONSTRAINT [PK_Embarque_Importacao_Documento] PRIMARY KEY CLUSTERED ([cd_embarque] ASC, [cd_tipo_documento_comex] ASC, [cd_tipo_relatorio_idioma] ASC) WITH (FILLFACTOR = 90)
);

