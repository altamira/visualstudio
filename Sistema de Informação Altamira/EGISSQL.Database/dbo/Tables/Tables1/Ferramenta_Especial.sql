CREATE TABLE [dbo].[Ferramenta_Especial] (
    [cd_ferramenta_especial]           INT      NOT NULL,
    [cd_pedido]                        INT      NULL,
    [cd_item_pedido]                   INT      NULL,
    [ds_aplicacao_ferramenta_especial] TEXT     NULL,
    [cd_usuario]                       INT      NULL,
    [dt_usuario]                       DATETIME NULL,
    PRIMARY KEY CLUSTERED ([cd_ferramenta_especial] ASC) WITH (FILLFACTOR = 90)
);

