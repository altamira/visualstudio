CREATE TABLE [dbo].[Cliente_Foco_Progresso] (
    [cd_cliente_foco_progresso] INT        NOT NULL,
    [cd_cliente]                INT        NULL,
    [cd_vendedor]               INT        NULL,
    [dt_cliente_foco_progresso] DATETIME   NULL,
    [vl_meta_cliente_foco]      FLOAT (53) NULL,
    [vl_planejado_cliente_foco] FLOAT (53) NULL,
    [vl_realizado_cliente_foco] FLOAT (53) NULL,
    [pc_cliente_foco]           FLOAT (53) NULL,
    [qt_tempo_cliente_foco]     FLOAT (53) NULL,
    [vl_tempo_cliente_foco]     FLOAT (53) NULL,
    [vl_real_cliente_foco]      FLOAT (53) NULL,
    [ds_cliente_foco_progresso] TEXT       NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [cd_criterio_visita]        INT        NULL,
    [cd_mes_referencia]         INT        NULL,
    [cd_ano_referencia]         INT        NULL,
    CONSTRAINT [PK_Cliente_Foco_Progresso] PRIMARY KEY CLUSTERED ([cd_cliente_foco_progresso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Foco_Progresso_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente]),
    CONSTRAINT [FK_Cliente_Foco_Progresso_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

