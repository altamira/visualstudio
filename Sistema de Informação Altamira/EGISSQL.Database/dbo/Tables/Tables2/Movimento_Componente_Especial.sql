CREATE TABLE [dbo].[Movimento_Componente_Especial] (
    [cd_pedido_venda]        INT          NULL,
    [cd_item_pedido_venda]   INT          NULL,
    [cd_item_comp_especial]  INT          NULL,
    [cd_movto_comp_especial] INT          NULL,
    [dt_movto_comp_especial] DATETIME     NULL,
    [cd_tipo_movto_comp_esp] INT          NULL,
    [nm_obs_movto_comp_esp]  VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL
);

