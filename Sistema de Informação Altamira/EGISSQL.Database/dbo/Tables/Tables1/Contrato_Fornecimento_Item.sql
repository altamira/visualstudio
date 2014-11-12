CREATE TABLE [dbo].[Contrato_Fornecimento_Item] (
    [cd_contrato_fornecimento]  INT          NOT NULL,
    [cd_item_contrato]          INT          NOT NULL,
    [cd_produto]                INT          NOT NULL,
    [dt_vigencia_inicial]       DATETIME     NOT NULL,
    [dt_vigencia_final]         DATETIME     NOT NULL,
    [cd_local_entrega]          INT          NOT NULL,
    [cd_forma_entrega]          INT          NOT NULL,
    [qt_total_recebida]         INT          NOT NULL,
    [qt_total_atraso]           INT          NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [nm_fantasia_produto]       VARCHAR (30) NULL,
    [nm_produto_contrato]       VARCHAR (50) NULL,
    [vl_lista_item_contrato]    FLOAT (53)   NULL,
    [vl_unitario_item_contrato] FLOAT (53)   NULL,
    [cd_fase_produto_contrato]  INT          NULL,
    [nm_kardex_item_contrato]   VARCHAR (30) NULL,
    [pc_desconto_item_contrato] FLOAT (53)   NULL,
    CONSTRAINT [PK_Contrato_Fornecimento_Item] PRIMARY KEY CLUSTERED ([cd_contrato_fornecimento] ASC, [cd_item_contrato] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Contrato_Fornecimento_Item_Forma_Entrega] FOREIGN KEY ([cd_forma_entrega]) REFERENCES [dbo].[Forma_Entrega] ([cd_forma_entrega])
);

