CREATE TABLE [dbo].[gond_tp_frt] (
    [Tipo_frente]        NVARCHAR (50) NULL,
    [valor]              INT           NULL,
    [dep_dimensoes]      BIT           NULL,
    [frente_lado_oposto] NVARCHAR (50) NULL,
    [sufixo_tipo]        NVARCHAR (2)  NULL,
    [incluir_estrutura]  BIT           NULL,
    [idGondTpFrt]        INT           IDENTITY (1, 1) NOT NULL,
    [prefixo_estrutura]  NVARCHAR (10) NULL
);

