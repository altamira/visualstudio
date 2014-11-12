CREATE TABLE [dbo].[Movimento_Venda_Opcional] (
    [cd_movimento_venda] INT        NOT NULL,
    [cd_opcional]        INT        NOT NULL,
    [qt_movimento_venda] FLOAT (53) NULL,
    [cd_usuario]         INT        NULL,
    [dt_usuario]         DATETIME   NULL,
    CONSTRAINT [PK_Movimento_Venda_Opcional] PRIMARY KEY CLUSTERED ([cd_movimento_venda] ASC, [cd_opcional] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Movimento_Venda_Opcional_Opcional_Veiculo] FOREIGN KEY ([cd_opcional]) REFERENCES [dbo].[Opcional_Veiculo] ([cd_opcional])
);

