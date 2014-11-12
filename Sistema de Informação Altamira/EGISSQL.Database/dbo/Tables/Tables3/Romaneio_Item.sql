CREATE TABLE [dbo].[Romaneio_Item] (
    [cd_romaneio]            INT          NOT NULL,
    [cd_item_romaneio]       INT          NULL,
    [cd_produto]             INT          NULL,
    [qt_produto_romaneio]    FLOAT (53)   NULL,
    [cd_programacao_entrega] INT          NULL,
    [dt_item_entrega]        DATETIME     NULL,
    [nm_obs_item_romaneio]   VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Romaneio_Item] PRIMARY KEY CLUSTERED ([cd_romaneio] ASC) WITH (FILLFACTOR = 90)
);

