CREATE TABLE [dbo].[DadosImpressaoOrcamento] (
    [idDadosOrcamento] INT            IDENTITY (1, 1) NOT NULL,
    [Chave]            NVARCHAR (255) NULL,
    [Descricao]        NVARCHAR (255) NULL,
    [Valores]          NVARCHAR (MAX) NULL,
    [valorPadrao]      NVARCHAR (255) NULL,
    [Referente]        NVARCHAR (255) NULL,
    [Ativo]            BIT            NOT NULL,
    [DescricaoGrupo]   NVARCHAR (255) NULL,
    CONSTRAINT [PK_DadosImpressaoOrcamento] PRIMARY KEY CLUSTERED ([idDadosOrcamento] ASC)
);

