CREATE TABLE [dbo].[Banco_Tarifa] (
    [cd_banco]             INT       NOT NULL,
    [cd_tipo_tarifa_banco] INT       NOT NULL,
    [cd_banco_tarifa]      CHAR (10) NOT NULL,
    [cd_usuario]           INT       NULL,
    [dt_usuario]           DATETIME  NULL,
    CONSTRAINT [PK_Banco_Tarifa] PRIMARY KEY CLUSTERED ([cd_banco] ASC, [cd_tipo_tarifa_banco] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Banco_Tarifa_Tipo_Tarifa_Banco] FOREIGN KEY ([cd_tipo_tarifa_banco]) REFERENCES [dbo].[Tipo_Tarifa_Banco] ([cd_tipo_tarifa_banco])
);

