CREATE TABLE [dbo].[Tipo_Alteracao_Pedido_Departamento] (
    [cd_tipo_alteracao_pedido] INT NOT NULL,
    [cd_departamento]          INT NOT NULL,
    CONSTRAINT [FK_Tipo_Alteracao_Pedido_Departamento_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

