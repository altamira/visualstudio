CREATE TABLE [dbo].[Laudo_Produto_Aplicacao] (
    [cd_produto]        INT      NOT NULL,
    [cd_tipo_aplicacao] INT      NOT NULL,
    [nm_aplicacao]      TEXT     NULL,
    [cd_usuario]        INT      NULL,
    [dt_usuario]        DATETIME NULL,
    CONSTRAINT [PK_Laudo_Produto_Aplicacao] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_tipo_aplicacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Laudo_Produto_Aplicacao_Tipo_Aplicacao] FOREIGN KEY ([cd_tipo_aplicacao]) REFERENCES [dbo].[Tipo_Aplicacao] ([cd_tipo_aplicacao])
);

