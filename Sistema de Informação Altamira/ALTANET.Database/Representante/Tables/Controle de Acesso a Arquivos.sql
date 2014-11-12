CREATE TABLE [Representante].[Controle de Acesso a Arquivos] (
    [Identificador]                       INT            IDENTITY (1, 1) NOT NULL,
    [Data do Acesso]                      DATETIME       CONSTRAINT [DF_Controle de Acesso a Arquivos_Data da Consulta] DEFAULT (getdate()) NOT NULL,
    [Identificador da Sessão]             INT            NOT NULL,
    [Identificador do Representante]      INT            NOT NULL,
    [Número do Orçamento]                 INT            NOT NULL,
    [Nome do Arquivo]                     NVARCHAR (50)  NOT NULL,
    [Extensão do Arquivo]                 NVARCHAR (50)  NULL,
    [Tamanho do Arquivo]                  INT            CONSTRAINT [DF_Controle de Acesso a Arquivos_Tamanho] DEFAULT ((0)) NOT NULL,
    [Localização do Arquivo]              NVARCHAR (MAX) NOT NULL,
    [Data de Criação do Arquivo]          DATETIME       NOT NULL,
    [Data da Última Alteração no Arquivo] DATETIME       NOT NULL,
    [Data do Último Acesso ao Arquivo]    DATETIME       NULL,
    [Quantidade de Acessos ao Arquivo]    INT            CONSTRAINT [DF_Controle de Acesso a Arquivos_Quantidade de Acessos] DEFAULT ((0)) NOT NULL,
    [Nome do Arquivo com Extensão]        AS             ([Nome do Arquivo]+[Extensão do Arquivo]),
    [Pasta Virtual]                       AS             (case when charindex('PDF-DRAW',[Localização do Arquivo])>(0) then 'Projeto' else 'Orçamento' end),
    CONSTRAINT [PK_Controle de Acesso a Arquivos] PRIMARY KEY CLUSTERED ([Identificador] ASC),
    CONSTRAINT [FK_Controle de Acesso a Arquivos_Representante] FOREIGN KEY ([Identificador do Representante]) REFERENCES [Representante].[Representante] ([Identificador]),
    CONSTRAINT [FK_Controle de Acesso a Arquivos_Sessão de Representante] FOREIGN KEY ([Identificador da Sessão]) REFERENCES [Representante].[Sessão de Representante] ([Identificador])
);

