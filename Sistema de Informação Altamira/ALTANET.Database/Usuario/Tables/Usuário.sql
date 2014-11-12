CREATE TABLE [Usuario].[Usuário] (
    [Identificador]                     INT            IDENTITY (1, 1) NOT NULL,
    [Nome]                              NVARCHAR (50)  NOT NULL,
    [Email]                             NVARCHAR (100) NOT NULL,
    [Usuario]                           NVARCHAR (50)  NOT NULL,
    [Senha]                             NVARCHAR (40)  NOT NULL,
    [Data de Criação]                   DATETIME       CONSTRAINT [DF_Usuario_DataCriacao] DEFAULT (getdate()) NOT NULL,
    [Criado Por]                        INT            CONSTRAINT [DF_Usuario_Criado_Por] DEFAULT ((1)) NOT NULL,
    [Data da Última Atualização]        DATETIME       CONSTRAINT [DF_Usuario_Data_da_Última_Atualização] DEFAULT (getdate()) NOT NULL,
    [Última Atualização Por]            INT            CONSTRAINT [DF_Usuario_[Última_Atualização_Por] DEFAULT ((1)) NOT NULL,
    [Data do Último Acesso]             DATETIME       NULL,
    [Data de Validade da Senha]         DATETIME       CONSTRAINT [DF_Usuario_Data de Validade da Senha] DEFAULT (getdate()) NOT NULL,
    [Data da Última Alteração da Senha] DATETIME       NULL,
    [Acesso Bloqueada]                  BIT            CONSTRAINT [DF_Usuario_Conta Inativa] DEFAULT ((0)) NOT NULL,
    [Número de Tentativas de Acesso]    INT            CONSTRAINT [DF_Usuario_Número de Tentativas de Acesso] DEFAULT ((0)) NOT NULL,
    [Número de Acessos]                 INT            CONSTRAINT [DF_Usuario_Número de Acessos] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Usuario.Id] PRIMARY KEY CLUSTERED ([Identificador] ASC)
);

