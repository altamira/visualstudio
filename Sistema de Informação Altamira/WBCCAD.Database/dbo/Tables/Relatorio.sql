CREATE TABLE [dbo].[Relatorio] (
    [idRelatorio]  INT            IDENTITY (1, 1) NOT NULL,
    [Relatorio]    NVARCHAR (255) NULL,
    [RelatorioPai] NVARCHAR (255) NULL,
    [Expressao]    NVARCHAR (MAX) NULL,
    [Observacoes]  NVARCHAR (MAX) NULL,
    [Ativo]        BIT            NOT NULL,
    [Padrao]       BIT            NOT NULL,
    CONSTRAINT [PK_Relatorio] PRIMARY KEY CLUSTERED ([idRelatorio] ASC)
);

