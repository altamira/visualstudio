CREATE TABLE [dbo].[quadro_acessorios] (
    [Descricao]      NVARCHAR (50) NULL,
    [sigla]          NVARCHAR (3)  NULL,
    [montar_codigo]  BIT           NULL,
    [codigo]         NVARCHAR (50) NULL,
    [quantidade]     NVARCHAR (50) NULL,
    [depende_regime] BIT           NULL,
    [regime]         NVARCHAR (10) NULL
);

