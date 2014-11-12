CREATE TABLE [dbo].[Parametro_Pedido_Compra] (
    [cd_empresa]              INT      NOT NULL,
    [ic_logotipo_ped_empresa] CHAR (1) NULL,
    [ic_endereco_pedido]      CHAR (1) NULL,
    [ic_pedido_venda]         CHAR (1) NULL,
    [ic_data_necessidade]     CHAR (1) NULL,
    [qt_fonte_item]           INT      NULL,
    [ic_desconto_item_pedido] CHAR (1) NULL,
    [ic_modelo_pedido_compra] CHAR (1) NULL,
    [ic_edita_email]          CHAR (1) NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    [ic_desc_tec_cotacao_emp] CHAR (1) NULL,
    [ic_desc_tec_pedido_emp]  CHAR (1) NULL,
    [ic_assinatura_pedido]    CHAR (1) NULL,
    [cd_documento_qualidade]  INT      NULL,
    [ic_somente_desc_tecnica] CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_Pedido_Compra] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Pedido_Compra_Documento_Qualidade] FOREIGN KEY ([cd_documento_qualidade]) REFERENCES [dbo].[Documento_Qualidade] ([cd_documento_qualidade])
);

