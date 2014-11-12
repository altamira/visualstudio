CREATE TABLE [Usuario].[Sessão de Usuário] (
    [Identificador]              INT              IDENTITY (1, 1) NOT NULL,
    [Identificador Único Global] UNIQUEIDENTIFIER CONSTRAINT [DF_Sessão de Usuário_Identificador Único Global] DEFAULT (newid()) NOT NULL,
    [Identificador do Usuário]   INT              CONSTRAINT [DF_Sessão de Usuário_Identificador do Representante] DEFAULT ((0)) NOT NULL,
    [Data de Criação]            DATETIME         CONSTRAINT [DF_Sessão de Usuário_Data de Criação] DEFAULT (getdate()) NOT NULL,
    [Data de Validade]           DATETIME         NOT NULL,
    [Endereço IP de Origem]      CHAR (15)        NULL,
    [Sessão Valida]              AS               (case when [Data de Validade]>getdate() then (1) else (0) end),
    CONSTRAINT [PK_Sessão de Usuário] PRIMARY KEY CLUSTERED ([Identificador] ASC),
    CONSTRAINT [FK_Sessão de Usuário_Usuário] FOREIGN KEY ([Identificador do Usuário]) REFERENCES [Usuario].[Usuário] ([Identificador])
);

