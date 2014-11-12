CREATE TABLE [dbo].[Pedido_Venda_Impressao] (
    [cd_pedido_venda] INT      NOT NULL,
    [cd_departamento] INT      NOT NULL,
    [cd_usuario]      INT      NULL,
    [dt_usuario]      DATETIME NULL,
    CONSTRAINT [PK_Pedido_Venda_Impressao] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_departamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Venda_Impressao_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

