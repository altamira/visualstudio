CREATE TABLE [dbo].[Contrato_Fornecimento_Item_Mes] (
    [cd_contrato_fornecimento_item] INT      NOT NULL,
    [cd_contrato_fornecimento]      INT      NOT NULL,
    [cd_item_contrato]              INT      NOT NULL,
    [cd_mes]                        INT      NOT NULL,
    [cd_ano]                        INT      NOT NULL,
    [qt_contrato_fornecimento]      INT      NULL,
    [qt_liberacao]                  INT      NULL,
    [dt_prevista_contrato]          DATETIME NULL,
    [dt_liberacao]                  DATETIME NULL,
    [cd_usuario]                    INT      NULL,
    [dt_usuario]                    DATETIME NULL,
    [cd_usuario_liberacao]          INT      NULL,
    [cd_pedido_venda]               INT      NULL,
    [cd_item_pedido_venda]          INT      NULL,
    [ic_reserva_estoque]            CHAR (1) NULL,
    CONSTRAINT [PK_Contrato_Fornecimento_Item_Mes] PRIMARY KEY CLUSTERED ([cd_contrato_fornecimento_item] ASC) WITH (FILLFACTOR = 90)
);

