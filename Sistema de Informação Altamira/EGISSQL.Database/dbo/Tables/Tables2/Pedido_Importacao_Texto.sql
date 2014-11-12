CREATE TABLE [dbo].[Pedido_Importacao_Texto] (
    [cd_pedido_importacao]      INT          NOT NULL,
    [cd_texto_pedido_importaca] INT          NOT NULL,
    [nm_texto_pedido_imp]       VARCHAR (40) NOT NULL,
    [ds_texto_pedido_imp]       TEXT         NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [cd_tipo_documento_comex]   INT          NULL,
    CONSTRAINT [PK_Pedido_Importacao_Texto] PRIMARY KEY CLUSTERED ([cd_pedido_importacao] ASC, [cd_texto_pedido_importaca] ASC) WITH (FILLFACTOR = 90)
);

