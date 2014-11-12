CREATE TABLE [dbo].[Ordem_Frota_Servico_Item] (
    [cd_ordem]                INT          NOT NULL,
    [cd_item_ordem]           INT          NOT NULL,
    [cd_tipo_servico_veiculo] INT          NULL,
    [qt_item_ordem]           FLOAT (53)   NULL,
    [vl_item_ordem]           FLOAT (53)   NULL,
    [ds_item_ordem]           TEXT         NULL,
    [nm_obs_item_ordem]       VARCHAR (40) NULL,
    [cd_instrucao_manutencao] INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [dt_item_ordem]           DATETIME     NULL,
    CONSTRAINT [PK_Ordem_Frota_Servico_Item] PRIMARY KEY CLUSTERED ([cd_ordem] ASC, [cd_item_ordem] ASC) WITH (FILLFACTOR = 90)
);

