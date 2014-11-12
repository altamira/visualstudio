CREATE TABLE [dbo].[Centro_Receita_Pedido_Venda] (
    [cd_pedido_venda]          INT        NOT NULL,
    [cd_centro_receita_pedido] INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [cd_usuario]               INT        NULL,
    [vl_centro_receita_pedido] FLOAT (53) NULL,
    [cd_departamento]          INT        NULL,
    [cd_centro_receita]        INT        NULL,
    CONSTRAINT [PK_Centro_Receita_Pedido_Venda] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Centro_Receita_Pedido_Venda_Centro_Receita] FOREIGN KEY ([cd_centro_receita]) REFERENCES [dbo].[Centro_Receita] ([cd_centro_receita]),
    CONSTRAINT [FK_Centro_Receita_Pedido_Venda_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

