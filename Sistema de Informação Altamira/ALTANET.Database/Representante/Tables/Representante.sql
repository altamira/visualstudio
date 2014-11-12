CREATE TABLE [Representante].[Representante] (
    [Identificador]                     INT            IDENTITY (1, 1) NOT NULL,
    [Código]                            NCHAR (3)      NOT NULL,
    [Nome]                              NVARCHAR (50)  NOT NULL,
    [Telefones de Contato]              XML            NULL,
    [Email]                             NVARCHAR (100) NOT NULL,
    [Senha]                             NVARCHAR (40)  NOT NULL,
    [Data de Criação]                   DATETIME       CONSTRAINT [DF_Representante_DataCriacao] DEFAULT (getdate()) NOT NULL,
    [Criado Por]                        INT            CONSTRAINT [DF_Representante_Criado_Por] DEFAULT ((1)) NOT NULL,
    [Data da Última Atualização]        DATETIME       CONSTRAINT [DF_Representante_Data_da_Última_Atualização] DEFAULT (getdate()) NOT NULL,
    [Última Atualização Por]            INT            CONSTRAINT [DF_Representante_[Última_Atualização_Por] DEFAULT ((1)) NOT NULL,
    [Data do Último Acesso]             DATETIME       NULL,
    [Data de Validade da Senha]         DATETIME       CONSTRAINT [DF_Representante_Data de Validade da Senha] DEFAULT (getdate()) NOT NULL,
    [Data da Última Alteração da Senha] DATETIME       NULL,
    [Acesso Bloqueado]                  BIT            CONSTRAINT [DF_Representante_Conta Inativa] DEFAULT ((0)) NOT NULL,
    [Número de Tentativas de Acesso]    INT            CONSTRAINT [DF_Representante_Número de Tentativas de Acesso] DEFAULT ((0)) NOT NULL,
    [Número de Acessos]                 INT            CONSTRAINT [DF_Representante_Número de Acessos] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Representante.Id] PRIMARY KEY CLUSTERED ([Identificador] ASC),
    CONSTRAINT [IX_Representante_Codigo] UNIQUE NONCLUSTERED ([Código] ASC)
);

