CREATE TABLE [dbo].[Cliente_Origem] (
    [cd_cliente_origem]          INT      NOT NULL,
    [cd_cliente]                 INT      NOT NULL,
    [ic_padrao_consulta]         CHAR (1) NULL,
    [ic_proposta_cliente_origem] CHAR (1) NULL,
    [ic_pedido_cliente_origem]   CHAR (1) NULL,
    [cd_usuario]                 INT      NULL,
    [dt_usuario]                 DATETIME NULL,
    CONSTRAINT [PK_Cliente_Origem] PRIMARY KEY CLUSTERED ([cd_cliente_origem] ASC, [cd_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Origem_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

