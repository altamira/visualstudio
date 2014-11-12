CREATE TABLE [dbo].[Cliente_Senha_Historico] (
    [cd_historico_senha] INT          NOT NULL,
    [cd_cliente]         INT          NOT NULL,
    [dt_historico_senha] DATETIME     NULL,
    [cd_senha_historico] VARCHAR (15) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Senha_Historico] PRIMARY KEY CLUSTERED ([cd_historico_senha] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Senha_Historico_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

