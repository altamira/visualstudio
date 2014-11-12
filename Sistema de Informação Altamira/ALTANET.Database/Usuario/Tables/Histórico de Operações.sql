CREATE TABLE [Usuario].[Histórico de Operações] (
    [Data e Hora]              DATETIME       CONSTRAINT [DF_Historico de Operação_Data e Hora] DEFAULT (getdate()) NOT NULL,
    [Identificador da Sessão]  INT            CONSTRAINT [DF_Histórico de Operações_Identificador da Sessão] DEFAULT ((0)) NULL,
    [Identificador do Usuário] INT            NULL,
    [Operação]                 NVARCHAR (50)  NOT NULL,
    [Histórico]                NVARCHAR (MAX) NULL,
    [Registros Afetados]       INT            CONSTRAINT [DF_Histórico de Operações_Registros Afetados] DEFAULT ((0)) NOT NULL
);

