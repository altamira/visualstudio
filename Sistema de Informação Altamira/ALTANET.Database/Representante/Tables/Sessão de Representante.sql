CREATE TABLE [Representante].[Sessão de Representante] (
    [Identificador]                  INT              IDENTITY (1, 1) NOT NULL,
    [Identificador Único Global]     UNIQUEIDENTIFIER CONSTRAINT [DF_Sessão_Identificação] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [Identificador do Representante] INT              CONSTRAINT [DF_Sessão_Identificação_do_Representante] DEFAULT ((0)) NOT NULL,
    [Código do Representante]        NCHAR (3)        NOT NULL,
    [Data de Criação]                DATETIME         CONSTRAINT [DF_Sessão_Data_de_Criação] DEFAULT (getdate()) NOT NULL,
    [Data de Validade]               DATETIME         NOT NULL,
    [Endereço IP de Origem]          CHAR (15)        NULL,
    [Sessão Valida]                  AS               (case when [Data de Validade]>getdate() then (1) else (0) end),
    CONSTRAINT [PK_Sessão_Representante] PRIMARY KEY CLUSTERED ([Identificador] ASC),
    CONSTRAINT [FK_Sessão de Representante_Representante] FOREIGN KEY ([Identificador do Representante]) REFERENCES [Representante].[Representante] ([Identificador]),
    CONSTRAINT [FK_Sessão de Representante_Representante1] FOREIGN KEY ([Código do Representante]) REFERENCES [Representante].[Representante] ([Código])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Sessão de Representante]
    ON [Representante].[Sessão de Representante]([Identificador Único Global] ASC);

