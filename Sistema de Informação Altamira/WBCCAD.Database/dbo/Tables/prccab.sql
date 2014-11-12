CREATE TABLE [dbo].[prccab] (
    [lista]          NVARCHAR (6)   NULL,
    [observacao]     NVARCHAR (255) NULL,
    [lista_produto]  NVARCHAR (20)  NULL,
    [lista_fator]    NVARCHAR (20)  NULL,
    [criacao]        DATETIME       NULL,
    [utilizacao_ini] DATETIME       NULL,
    [utilizacao_fim] DATETIME       NULL,
    [cliente]        NVARCHAR (18)  NULL,
    [importacao]     DATETIME       NULL,
    [moeda]          NVARCHAR (4)   NULL,
    [PrcCabListaCor] NVARCHAR (20)  NULL,
    [INTEGRACAO]     NVARCHAR (255) NULL,
    [PRCVAL_CODIGO]  NVARCHAR (20)  NULL,
    [idPrccab]       INT            IDENTITY (1, 1) NOT NULL,
    [lista_calculo]  NVARCHAR (20)  NULL,
    CONSTRAINT [PK_prccab] PRIMARY KEY CLUSTERED ([idPrccab] ASC)
);

