CREATE TABLE [dbo].[Banco_Tipo_Movimento_Pagamento] (
    [cd_banco]                INT       NOT NULL,
    [cd_tipo_movimento]       INT       NOT NULL,
    [sg_tipo_movimento_banco] CHAR (10) NULL,
    [cd_usuario]              INT       NULL,
    CONSTRAINT [PK_Banco_Tipo_Movimento_Pagamento] PRIMARY KEY CLUSTERED ([cd_banco] ASC, [cd_tipo_movimento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Banco_Tipo_Movimento_Pagamento_Tipo_Movimento_Pagamento] FOREIGN KEY ([cd_tipo_movimento]) REFERENCES [dbo].[Tipo_Movimento_Pagamento] ([cd_tipo_movimento])
);

