CREATE TABLE [dbo].[Clube_Responsavel_Cadastro] (
    [cd_responsavel_cadastro] INT      NOT NULL,
    [cd_clube_responsavel]    INT      NOT NULL,
    [cd_cadastro]             INT      NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    CONSTRAINT [PK_Clube_Responsavel_Cadastro] PRIMARY KEY CLUSTERED ([cd_responsavel_cadastro] ASC),
    CONSTRAINT [FK_Clube_Responsavel_Cadastro_Clube_Cadastro] FOREIGN KEY ([cd_cadastro]) REFERENCES [dbo].[Clube_Cadastro] ([cd_cadastro])
);

