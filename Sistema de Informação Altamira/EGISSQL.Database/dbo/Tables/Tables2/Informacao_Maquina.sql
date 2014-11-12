CREATE TABLE [dbo].[Informacao_Maquina] (
    [cd_informacao_maquina]     INT        NOT NULL,
    [cd_cliente]                INT        NULL,
    [cd_vendedor]               INT        NULL,
    [ds_informacao_maquina]     TEXT       NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [dt_informacao_maquina]     DATETIME   NULL,
    [vl_potencial_inf_maquina]  FLOAT (53) NULL,
    [qt_maq_informacao_maquina] INT        NULL,
    CONSTRAINT [PK_Informacao_Maquina] PRIMARY KEY CLUSTERED ([cd_informacao_maquina] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Informacao_Maquina_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente]),
    CONSTRAINT [FK_Informacao_Maquina_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

