CREATE TABLE [dbo].[TABREGRA backup] (
    [TipoVenda]             NVARCHAR (50)  NULL,
    [GrupoImpostos]         NVARCHAR (50)  NULL,
    [GrupoProduto]          INT            NULL,
    [IcmsFator]             MONEY          NULL,
    [IcmsRedutor]           MONEY          NULL,
    [IpiFator]              MONEY          NULL,
    [Natureza]              NVARCHAR (20)  NULL,
    [PISCOFINSFATOR]        MONEY          NULL,
    [VERIFICAR]             BIT            NULL,
    [PISFATOR]              MONEY          NULL,
    [COFINSFATOR]           MONEY          NULL,
    [TABREGRA_NODESCRITIVO] NVARCHAR (MAX) NULL,
    [ROYALTIES_CALCULO]     MONEY          NULL,
    [CUSTO_CALCULO]         MONEY          NULL,
    [REPASSE_CALCULO]       MONEY          NULL,
    [FRETE_CALCULO]         MONEY          NULL,
    [INDICE_COMPRA]         MONEY          NULL,
    [INDICE_FATURAMENTO]    MONEY          NULL,
    [IPI_NAO_INCLUSO]       MONEY          NULL,
    [idTABREGRA]            INT            IDENTITY (1, 1) NOT NULL
);

