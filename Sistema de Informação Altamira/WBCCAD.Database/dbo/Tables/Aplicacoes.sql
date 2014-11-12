CREATE TABLE [dbo].[Aplicacoes] (
    [idAplicacao]      INT            IDENTITY (1, 1) NOT NULL,
    [AplicacaoPT]      NVARCHAR (100) NULL,
    [AplicacaoEN]      NVARCHAR (255) NULL,
    [AplicacaoES]      NVARCHAR (255) NULL,
    [Executavel]       NVARCHAR (100) NULL,
    [Parametros]       NVARCHAR (MAX) NULL,
    [Observacoes]      NVARCHAR (MAX) NULL,
    [Ativa]            BIT            NOT NULL,
    [Principal]        BIT            NOT NULL,
    [ArquivosPrograma] BIT            NOT NULL,
    [chave]            NVARCHAR (255) NULL
);

