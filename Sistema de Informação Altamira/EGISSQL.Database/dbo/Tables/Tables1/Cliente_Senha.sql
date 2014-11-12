CREATE TABLE [dbo].[Cliente_Senha] (
    [cd_cliente]           INT           NOT NULL,
    [dt_cadastro_senha]    DATETIME      NULL,
    [cd_senha_cliente]     VARCHAR (15)  NULL,
    [nm_frase_senha]       VARCHAR (150) NULL,
    [nm_dica_senha]        VARCHAR (150) NULL,
    [qt_acesso_cliente]    INT           NULL,
    [dt_acesso_cliente]    DATETIME      NULL,
    [nm_obs_cliente_senha] VARCHAR (150) NULL,
    [cd_usuario]           INT           NULL,
    [dt_usuario]           DATETIME      NULL,
    [cd_coordenador]       INT           NULL,
    CONSTRAINT [PK_Cliente_Senha] PRIMARY KEY CLUSTERED ([cd_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Senha_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente]),
    CONSTRAINT [FK_Cliente_Senha_Coordenador] FOREIGN KEY ([cd_coordenador]) REFERENCES [dbo].[Coordenador] ([cd_coordenador])
);

