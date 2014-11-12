CREATE TABLE [dbo].[Departamento_Aviso_Pedido_Venda] (
    [cd_departamento]       INT      NOT NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    [cd_departamento_aviso] INT      NOT NULL,
    CONSTRAINT [PK_Departamento_Aviso_Pedido_Venda] PRIMARY KEY CLUSTERED ([cd_departamento_aviso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Departamento_Aviso_Pedido_Venda_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

