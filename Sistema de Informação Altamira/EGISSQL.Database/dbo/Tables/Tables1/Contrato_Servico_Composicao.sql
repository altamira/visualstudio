CREATE TABLE [dbo].[Contrato_Servico_Composicao] (
    [cd_contrato_servico]      INT          NOT NULL,
    [cd_item_contrato_servico] INT          NOT NULL,
    [dt_parc_contrato_servico] DATETIME     NULL,
    [vl_parc_contrato_servico] FLOAT (53)   NULL,
    [cd_nota_saida]            INT          NULL,
    [nm_parc_contrato_servico] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [vl_descto_parc_contrato]  FLOAT (53)   NULL,
    [cd_item_pedido_venda]     INT          NULL,
    [cd_pedido_venda]          INT          NULL,
    CONSTRAINT [PK_Contrato_Servico_Composicao] PRIMARY KEY CLUSTERED ([cd_contrato_servico] ASC, [cd_item_contrato_servico] ASC) WITH (FILLFACTOR = 90)
);

