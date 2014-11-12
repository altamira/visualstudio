CREATE TABLE [dbo].[Romaneio] (
    [cd_romaneio]             INT      NOT NULL,
    [dt_romaneio]             DATETIME NULL,
    [cd_cliente]              INT      NULL,
    [dt_faturamento_romaneio] DATETIME NULL,
    [dt_entrega_romaneio]     DATETIME NULL,
    [ds_romaneio]             TEXT     NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    CONSTRAINT [PK_Romaneio] PRIMARY KEY CLUSTERED ([cd_romaneio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Romaneio_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

