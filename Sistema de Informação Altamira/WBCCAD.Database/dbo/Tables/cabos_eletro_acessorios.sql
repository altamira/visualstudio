CREATE TABLE [dbo].[cabos_eletro_acessorios] (
    [dep_dia1]            BIT           NOT NULL,
    [dep_dia2]            BIT           NOT NULL,
    [qtde_por_compr]      BIT           NOT NULL,
    [multiplo]            INT           NULL,
    [qtde_p_linha]        INT           NULL,
    [chave]               NVARCHAR (50) NULL,
    [compr_min_p_incluir] INT           NULL,
    [valido_somente_uc]   BIT           NOT NULL,
    [desenho]             NVARCHAR (50) NULL
);

