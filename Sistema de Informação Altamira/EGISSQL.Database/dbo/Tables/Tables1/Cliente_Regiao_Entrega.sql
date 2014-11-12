CREATE TABLE [dbo].[Cliente_Regiao_Entrega] (
    [cd_cliente_regiao]        INT        NOT NULL,
    [vl_entrega_pedido_regiao] FLOAT (53) NULL,
    [cd_tipo_local_entrega]    INT        NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    CONSTRAINT [PK_Cliente_Regiao_Entrega] PRIMARY KEY CLUSTERED ([cd_cliente_regiao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Regiao_Entrega_Tipo_Local_Entrega] FOREIGN KEY ([cd_tipo_local_entrega]) REFERENCES [dbo].[Tipo_Local_Entrega] ([cd_tipo_local_entrega])
);

