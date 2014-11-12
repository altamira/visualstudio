CREATE TABLE [dbo].[Meta_Entrega] (
    [cd_entregador]       INT          NOT NULL,
    [dt_inicio_meta]      DATETIME     NOT NULL,
    [dt_final_meta]       DATETIME     NOT NULL,
    [qt_entrega_meta]     INT          NULL,
    [vl_entrega_meta]     FLOAT (53)   NULL,
    [nm_obs_meta_entrega] VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Meta_Entrega] PRIMARY KEY CLUSTERED ([cd_entregador] ASC, [dt_inicio_meta] ASC, [dt_final_meta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Meta_Entrega_Entregador] FOREIGN KEY ([cd_entregador]) REFERENCES [dbo].[Entregador] ([cd_entregador])
);

