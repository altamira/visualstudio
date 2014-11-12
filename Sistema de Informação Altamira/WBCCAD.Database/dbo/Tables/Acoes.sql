CREATE TABLE [dbo].[Acoes] (
    [idAcao]           INT            IDENTITY (1, 1) NOT NULL,
    [idAcaoPai]        INT            NULL,
    [idTipoAcao]       INT            NOT NULL,
    [idAplicacao]      INT            NOT NULL,
    [AcaoPT]           NVARCHAR (255) NULL,
    [AcaoEN]           NVARCHAR (255) NULL,
    [AcaoES]           NVARCHAR (255) NULL,
    [Chave]            NVARCHAR (100) NOT NULL,
    [LinhaComando]     NVARCHAR (255) NULL,
    [DiretorioInicial] NVARCHAR (255) NULL,
    [Parametros]       NVARCHAR (MAX) NULL,
    [ObservacoesPT]    NVARCHAR (MAX) NULL,
    [ObservacoesEN]    NVARCHAR (MAX) NULL,
    [ObservacoesES]    NVARCHAR (MAX) NULL,
    [Exibir]           BIT            NOT NULL
);

