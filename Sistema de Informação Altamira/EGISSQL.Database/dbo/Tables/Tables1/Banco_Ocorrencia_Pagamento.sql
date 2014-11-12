CREATE TABLE [dbo].[Banco_Ocorrencia_Pagamento] (
    [cd_banco] INT NOT NULL,
    CONSTRAINT [PK_Banco_Ocorrencia_Pagamento] PRIMARY KEY CLUSTERED ([cd_banco] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Banco_Ocorrencia_Pagamento_Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco])
);

