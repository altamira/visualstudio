CREATE TABLE [dbo].[Informações Adicionais do Orçamento] (
    [Número do Orçamento]              INT            NOT NULL,
    [Identificador do Representante]   INT            CONSTRAINT [DF_Informações Adicionais do Orçamento_Identificador do Representante] DEFAULT ((0)) NOT NULL,
    [Identificador da Sessão]          INT            CONSTRAINT [DF_Informações Adicionais do Orçamento_Identificador da Sessão] DEFAULT ((0)) NULL,
    [Data da Última Atualização]       DATETIME       CONSTRAINT [DF_Informações Adicionais do Orçamento_Data da Última Atualização] DEFAULT (getdate()) NOT NULL,
    [Data do Próximo Contato]          DATE           CONSTRAINT [DF_Informações Adicionais do Orçamento_Data do Próximo Contato] DEFAULT (dateadd(day,(10),getdate())) NULL,
    [Probabilidade de Fechamento]      NUMERIC (3)    CONSTRAINT [DF_Table_1_[Probabilidade de Fechamento] DEFAULT ((0)) NOT NULL,
    [Principais Tipos de Materiais]    NVARCHAR (MAX) NULL,
    [Outros Tipos de Materiais]        NVARCHAR (50)  NULL,
    [Nome dos Principais Concorrentes] NVARCHAR (MAX) NULL,
    [Nome de Outros Concorrentes]      NVARCHAR (50)  NULL,
    [Última Situação Informada]        NVARCHAR (50)  CONSTRAINT [DF_Informações Adicionais do Orçamento_Situação] DEFAULT ('Pendente') NOT NULL,
    CONSTRAINT [PK_Acompanhamento do Orçamento] PRIMARY KEY CLUSTERED ([Número do Orçamento] ASC, [Identificador do Representante] ASC)
);

