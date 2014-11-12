CREATE TABLE [dbo].[gab_cab] (
    [descricao]             NVARCHAR (30) NULL,
    [grupo]                 NVARCHAR (20) NULL,
    [codigo_produto]        NVARCHAR (20) NULL,
    [desenho]               NVARCHAR (50) NULL,
    [largura]               FLOAT (53)    NULL,
    [esconder_orcamento]    BIT           NOT NULL,
    [sequencia_para_edicao] INT           NULL,
    [e_intermediaria]       BIT           NOT NULL
);

