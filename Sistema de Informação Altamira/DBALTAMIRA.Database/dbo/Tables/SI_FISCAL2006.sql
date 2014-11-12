CREATE TABLE [dbo].[SI_FISCAL2006] (
    [CÓD]           INT            NOT NULL,
    [NotaFiscal]    FLOAT (53)     NULL,
    [Data]          SMALLDATETIME  NULL,
    [Classificacao] FLOAT (53)     NULL,
    [Unidade]       NVARCHAR (255) NULL,
    [Quant]         FLOAT (53)     NULL,
    [VlrUnitario]   FLOAT (53)     NULL,
    [%ICMS]         NVARCHAR (255) NULL,
    [ICMS]          FLOAT (53)     NULL,
    [PIS]           FLOAT (53)     NULL,
    [COFINS]        FLOAT (53)     NULL,
    [TOTAL]         FLOAT (53)     NULL,
    [TotalSemICM]   FLOAT (53)     NULL,
    [TotalLiquido]  FLOAT (53)     NULL
);

