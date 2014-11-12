CREATE TABLE [dbo].[Usuario_Grupo_Ocorrecia_Pedido_venda] (
    [cd_usuario_ocorrencia]      INT      NOT NULL,
    [cd_grupo_ocorrencia_pedido] INT      NOT NULL,
    [cd_usuario]                 INT      NULL,
    [dt_usuario]                 DATETIME NULL,
    CONSTRAINT [PK_Usuario_Grupo_Ocorrecia_Pedido_venda] PRIMARY KEY CLUSTERED ([cd_usuario_ocorrencia] ASC, [cd_grupo_ocorrencia_pedido] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Usuario_Grupo_Ocorrecia_Pedido_venda_Grupo_Ocorrencia_Pedido_Venda] FOREIGN KEY ([cd_grupo_ocorrencia_pedido]) REFERENCES [dbo].[Grupo_Ocorrencia_Pedido_Venda] ([cd_grupo_ocorrencia_pedido])
);

