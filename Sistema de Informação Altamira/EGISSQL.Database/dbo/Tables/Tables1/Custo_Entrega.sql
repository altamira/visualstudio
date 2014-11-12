CREATE TABLE [dbo].[Custo_Entrega] (
    [cd_entregador]             INT          NOT NULL,
    [dt_custo_entrega]          DATETIME     NOT NULL,
    [vl_custo_entrega]          FLOAT (53)   NULL,
    [vl_adicional_meta_entrega] FLOAT (53)   NULL,
    [nm_obs_custo_entrega]      VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Custo_Entrega] PRIMARY KEY CLUSTERED ([cd_entregador] ASC, [dt_custo_entrega] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Custo_Entrega_Entregador] FOREIGN KEY ([cd_entregador]) REFERENCES [dbo].[Entregador] ([cd_entregador])
);

