CREATE TABLE [dbo].[Lista_Equipamento] (
    [cd_lista_equipamento] INT          NOT NULL,
    [cd_vendedor]          INT          NULL,
    [cd_cliente]           INT          NULL,
    [dt_lista_equipamento] DATETIME     NULL,
    [nm_maquina_lista]     VARCHAR (40) NULL,
    [vl_demanda_lista]     FLOAT (53)   NULL,
    [ds_lista_equipamento] TEXT         NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Lista_Equipamento] PRIMARY KEY CLUSTERED ([cd_lista_equipamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Lista_Equipamento_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente]),
    CONSTRAINT [FK_Lista_Equipamento_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

