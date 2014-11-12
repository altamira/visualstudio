CREATE TABLE [dbo].[Componente_Especial] (
    [cd_pedido_venda]           INT          NULL,
    [cd_item_pedido_venda]      INT          NULL,
    [cd_item_comp_especial]     INT          NULL,
    [dt_atualizacao_comp_esp]   DATETIME     NULL,
    [cd_processo]               INT          NULL,
    [qt_componente_especial]    FLOAT (53)   NULL,
    [cd_requisicao_compra]      INT          NULL,
    [nm_componente_especial]    VARCHAR (40) NULL,
    [nm_obs_comp_especial]      VARCHAR (60) NULL,
    [dt_necessidade_comp_esp]   DATETIME     NULL,
    [dt_entrega_comp_especial]  DATETIME     NULL,
    [dt_producao_comp_especial] DATETIME     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL
);

