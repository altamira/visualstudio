CREATE TABLE [dbo].[TiposAcoes] (
    [idTipoAcao]  INT            IDENTITY (1, 1) NOT NULL,
    [TipoAcao]    NVARCHAR (100) NULL,
    [Ordem]       INT            NULL,
    [Observacoes] NVARCHAR (MAX) NULL
);

