CREATE TABLE [dbo].[Transportadora_Veiculo] (
    [cd_transportadora]         INT         NOT NULL,
    [cd_transportadora_veiculo] INT         NULL,
    [cd_placa_transportadora]   VARCHAR (8) NULL,
    [cd_usuario]                INT         NULL,
    [dt_usuario]                DATETIME    NULL,
    CONSTRAINT [PK_Transportadora_Veiculo] PRIMARY KEY CLUSTERED ([cd_transportadora] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Transportadora_Veiculo_Transportadora] FOREIGN KEY ([cd_transportadora]) REFERENCES [dbo].[Transportadora] ([cd_transportadora])
);

