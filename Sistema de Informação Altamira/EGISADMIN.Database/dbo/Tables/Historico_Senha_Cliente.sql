CREATE TABLE [dbo].[Historico_Senha_Cliente] (
    [dt_troca_senha]           DATETIME     NOT NULL,
    [cd_cliente_sistema]       INT          NOT NULL,
    [cd_usuario_sistema]       INT          NOT NULL,
    [cd_senha_usuario_sistema] VARCHAR (10) NOT NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Historico_Senha_Cliente] PRIMARY KEY CLUSTERED ([dt_troca_senha] ASC, [cd_cliente_sistema] ASC, [cd_usuario_sistema] ASC) WITH (FILLFACTOR = 90)
);

