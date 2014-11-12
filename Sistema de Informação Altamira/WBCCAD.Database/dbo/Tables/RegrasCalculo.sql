CREATE TABLE [dbo].[RegrasCalculo] (
    [idRegraCalculo]      INT            IDENTITY (1, 1) NOT NULL,
    [idListaFatorCalculo] INT            NULL,
    [idTipoVenda]         INT            NULL,
    [idGrupoImposto]      INT            NULL,
    [idGrupo]             INT            NULL,
    [idSubgrupo]          INT            NULL,
    [idFormula]           INT            NULL,
    [descritivoRegra]     NVARCHAR (MAX) NULL
);

