CREATE TABLE [dbo].[Produto_Tecnica] (
    [cd_produto]         INT      NOT NULL,
    [ds_produto_tecnica] TEXT     NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    CONSTRAINT [PK_Produto_Tecnica] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90)
);

