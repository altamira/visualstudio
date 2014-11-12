CREATE TABLE [dbo].[Produto_Entrega] (
    [cd_produto]                  INT      NOT NULL,
    [qt_dia_entrega_produto]      INT      NULL,
    [ds_mensagem_entrega_produto] TEXT     NULL,
    [cd_usuario]                  INT      NULL,
    [dt_usuario]                  DATETIME NULL,
    [ds_mensagem_entrega]         TEXT     NULL,
    CONSTRAINT [PK_Produto_Entrega] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90)
);

