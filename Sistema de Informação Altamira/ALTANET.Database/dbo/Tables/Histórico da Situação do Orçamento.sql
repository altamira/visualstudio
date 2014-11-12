CREATE TABLE [dbo].[Histórico da Situação do Orçamento] (
    [Número do Orçamento]            INT            NOT NULL,
    [Última Atualização]             DATETIME       CONSTRAINT [DF_Histórico da Situação do Orçamento_Data e Hora] DEFAULT (getdate()) NOT NULL,
    [Identificador da Sessão]        INT            CONSTRAINT [DF_Histórico da Situação do Orçamento_Identificador da Sessão] DEFAULT ((0)) NULL,
    [Identificador do Representante] INT            CONSTRAINT [DF_Histórico da Situação do Orçamento_Identificador do Representante] DEFAULT ((0)) NULL,
    [Situação]                       NVARCHAR (50)  NOT NULL,
    [Observações]                    NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Histórico da Situação do Orçamento] PRIMARY KEY CLUSTERED ([Número do Orçamento] ASC, [Última Atualização] ASC)
);

