CREATE TABLE [dbo].[ConfiguracoesTabelas] (
    [idTabela]   INT            IDENTITY (1, 1) NOT NULL,
    [NomeTabela] NVARCHAR (100) NULL,
    [StringXML]  NVARCHAR (MAX) NULL
);

