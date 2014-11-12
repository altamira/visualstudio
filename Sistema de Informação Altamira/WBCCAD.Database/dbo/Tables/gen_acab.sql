CREATE TABLE [dbo].[gen_acab] (
    [indice]               INT           IDENTITY (1, 1) NOT NULL,
    [nome]                 NVARCHAR (50) NULL,
    [sigla]                NVARCHAR (10) NULL,
    [GenGrpPrecoCodigo]    NVARCHAR (50) NULL,
    [TRAVAR_REPRESENTANTE] BIT           NULL,
    [cor_cad]              NVARCHAR (5)  NULL,
    [exibirOrcamento]      BIT           NULL,
    [integracao]           VARCHAR (255) NULL
);

