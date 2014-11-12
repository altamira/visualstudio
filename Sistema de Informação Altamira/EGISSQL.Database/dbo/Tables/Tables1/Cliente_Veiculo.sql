CREATE TABLE [dbo].[Cliente_Veiculo] (
    [cd_cliente]         INT         NULL,
    [cd_cliente_veiculo] INT         NOT NULL,
    [cd_placa_veiculo]   VARCHAR (8) NULL,
    [cd_usuario]         INT         NULL,
    [dt_usuario]         DATETIME    NULL,
    CONSTRAINT [PK_Cliente_Veiculo] PRIMARY KEY CLUSTERED ([cd_cliente_veiculo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Veiculo_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

