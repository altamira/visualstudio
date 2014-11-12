CREATE TABLE [dbo].[Contrato_Compra_Composicao] (
    [cd_contrato_compra]      INT          NOT NULL,
    [cd_item_contrato_compra] INT          NOT NULL,
    [cd_produto]              INT          NULL,
    [cd_servico]              INT          NULL,
    [qt_item_contrato_compra] FLOAT (53)   NULL,
    [vl_item_contrato_compra] FLOAT (53)   NULL,
    [qt_leadtime_entrega]     INT          NULL,
    [nm_obs_item_contrato]    VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Contrato_Compra_Composicao] PRIMARY KEY CLUSTERED ([cd_contrato_compra] ASC, [cd_item_contrato_compra] ASC) WITH (FILLFACTOR = 90)
);

