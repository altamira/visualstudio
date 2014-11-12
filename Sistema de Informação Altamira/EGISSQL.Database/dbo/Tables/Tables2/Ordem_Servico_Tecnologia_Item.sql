CREATE TABLE [dbo].[Ordem_Servico_Tecnologia_Item] (
    [cd_os_tecnologia]          INT          NOT NULL,
    [cd_item_os_tecnologia]     INT          NOT NULL,
    [qt_dia_item_os_tecnologia] INT          NULL,
    [qt_hora_item_os_tecnologi] FLOAT (53)   NULL,
    [cd_servico]                INT          NULL,
    [nm_item_os_tecnologia]     VARCHAR (80) NULL,
    [dt_item_os_tecnologia]     DATETIME     NULL,
    [ds_item_os_tecnologia]     TEXT         NULL,
    [cd_tipo_os_tecnologia]     INT          NULL,
    [qt_hora_item_os_tecno]     FLOAT (53)   NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Ordem_Servico_Tecnologia_Item] PRIMARY KEY CLUSTERED ([cd_os_tecnologia] ASC, [cd_item_os_tecnologia] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Ordem_Servico_Tecnologia_Item_Ordem_Servico_Tecnologia] FOREIGN KEY ([cd_os_tecnologia]) REFERENCES [dbo].[Ordem_Servico_Tecnologia] ([cd_os_tecnologia]) ON DELETE CASCADE ON UPDATE CASCADE
);

