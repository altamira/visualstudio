CREATE TABLE [dbo].[Cliente_Conceito_Vendas] (
    [cd_conceito_cliente] INT          NOT NULL,
    [cd_item_conceito]    INT          NOT NULL,
    [vl_inicio_venda]     FLOAT (53)   NULL,
    [vl_fim_venda]        FLOAT (53)   NULL,
    [qt_ordem_conceito]   INT          NULL,
    [nm_obs_conceito]     VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [cd_criterio_visita]  INT          NULL,
    CONSTRAINT [PK_Cliente_Conceito_Vendas] PRIMARY KEY CLUSTERED ([cd_conceito_cliente] ASC, [cd_item_conceito] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Conceito_Vendas_Cliente_Conceito] FOREIGN KEY ([cd_conceito_cliente]) REFERENCES [dbo].[Cliente_Conceito] ([cd_conceito_cliente]),
    CONSTRAINT [FK_Cliente_Conceito_Vendas_Criterio_Visita] FOREIGN KEY ([cd_criterio_visita]) REFERENCES [dbo].[Criterio_Visita] ([cd_criterio_visita])
);

