CREATE TABLE [dbo].[Usuario_Cliente_Sistema] (
    [cd_cliente_sistema]       INT          NOT NULL,
    [cd_usuario_sistema]       INT          NOT NULL,
    [nm_usuario_sistema]       VARCHAR (40) NOT NULL,
    [nm_fantasia_usuario]      VARCHAR (15) NOT NULL,
    [cd_senha_usuario_sistema] VARCHAR (10) NOT NULL,
    [ic_ativo_usuario_sistema] CHAR (1)     NULL,
    [dt_nascimento_usuario]    DATETIME     NULL,
    [nm_obs_usuario_sistema]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_ordem_cliente_sistema] INT          NULL,
    CONSTRAINT [PK_Usuario_Cliente_Sistema] PRIMARY KEY CLUSTERED ([cd_cliente_sistema] ASC, [cd_usuario_sistema] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Usuario_Cliente_Sistema_Cliente_Sistema] FOREIGN KEY ([cd_cliente_sistema]) REFERENCES [dbo].[Cliente_Sistema] ([cd_cliente_sistema])
);

