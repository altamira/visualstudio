CREATE TABLE [dbo].[Centro_Custo_Pedido_Compra] (
    [cd_pedido_compra]          INT        NOT NULL,
    [cd_centro_custo_pd_compra] INT        NOT NULL,
    [cd_centro_custo]           INT        NULL,
    [cd_departamento]           INT        NULL,
    [vl_centro_custo_pedido]    FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Centro_Custo_Pedido_Compra] PRIMARY KEY CLUSTERED ([cd_pedido_compra] ASC, [cd_centro_custo_pd_compra] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Centro_Custo_Pedido_Compra_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo]),
    CONSTRAINT [FK_Centro_Custo_Pedido_Compra_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

