CREATE TABLE [dbo].[Cliente_Grafica] (
    [cd_cliente]             INT           NOT NULL,
    [ds_cliente_grafica]     TEXT          NULL,
    [qt_pinca_cliente]       FLOAT (53)    NULL,
    [ic_forno_chapa]         CHAR (1)      NULL,
    [qt_espessura_chapa]     FLOAT (53)    NULL,
    [qt_largura_chapa]       FLOAT (53)    NULL,
    [qt_comprimento_chapa]   FLOAT (53)    NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    [ic_portaria_cliente]    CHAR (1)      NULL,
    [qt_lpi_cliente_grafica] FLOAT (53)    NULL,
    [nm_ftp_cliente]         VARCHAR (150) NULL,
    [cd_cliente_grafica]     INT           NOT NULL,
    [cd_produto]             INT           NOT NULL,
    CONSTRAINT [PK_Cliente_Grafica] PRIMARY KEY CLUSTERED ([cd_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Grafica_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

