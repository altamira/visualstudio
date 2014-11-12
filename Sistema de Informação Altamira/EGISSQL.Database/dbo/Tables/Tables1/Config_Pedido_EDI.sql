CREATE TABLE [dbo].[Config_Pedido_EDI] (
    [cd_empresa]                 INT        NOT NULL,
    [cd_tipo_pedido]             INT        NULL,
    [cd_usuario]                 INT        NULL,
    [dt_usuario]                 DATETIME   NULL,
    [ic_gera_transporte]         CHAR (1)   NULL,
    [vl_limite_credito]          FLOAT (53) NULL,
    [ic_tipo_pedido_compra]      CHAR (1)   NULL,
    [ic_geracao_nota_automatica] CHAR (1)   NULL,
    [cd_operacao_fiscal]         INT        NULL,
    [cd_transportadora]          INT        NULL,
    [cd_usuario_credito]         INT        NULL,
    [ic_libera_credito]          CHAR (1)   NULL,
    CONSTRAINT [PK_Config_Pedido_EDI] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Config_Pedido_EDI_Operacao_Fiscal] FOREIGN KEY ([cd_operacao_fiscal]) REFERENCES [dbo].[Operacao_Fiscal] ([cd_operacao_fiscal]),
    CONSTRAINT [FK_Config_Pedido_EDI_Tipo_Pedido] FOREIGN KEY ([cd_tipo_pedido]) REFERENCES [dbo].[Tipo_Pedido] ([cd_tipo_pedido]),
    CONSTRAINT [FK_Config_Pedido_EDI_Transportadora] FOREIGN KEY ([cd_transportadora]) REFERENCES [dbo].[Transportadora] ([cd_transportadora]),
    CONSTRAINT [FK_Config_Pedido_EDI_Usuario] FOREIGN KEY ([cd_usuario_credito]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

