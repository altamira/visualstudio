CREATE TABLE [dbo].[Movimento_WorkFlow_Aprovacao] (
    [cd_movimento]         INT      NOT NULL,
    [cd_item_aprovacao]    INT      NOT NULL,
    [cd_tipo_aprovacao]    INT      NOT NULL,
    [cd_usuario_aprovacao] INT      NULL,
    [dt_usuario_aprovacao] DATETIME NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Movimento_WorkFlow_Aprovacao] PRIMARY KEY CLUSTERED ([cd_movimento] ASC, [cd_item_aprovacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Movimento_WorkFlow_Aprovacao_Usuario] FOREIGN KEY ([cd_usuario_aprovacao]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

