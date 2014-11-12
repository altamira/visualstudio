CREATE TABLE [dbo].[prcprdbk] (
    [Prcprdcab_descricao]    NVARCHAR (20) NOT NULL,
    [Produto]                NVARCHAR (20) NOT NULL,
    [Sigla_Cor]              NVARCHAR (10) NOT NULL,
    [Preco]                  FLOAT (53)    NULL,
    [Ipi]                    FLOAT (53)    NULL,
    [Icms]                   FLOAT (53)    NULL,
    [PRCPRD_ADICIONAL]       SMALLMONEY    NULL,
    [LP_PRCPRD_COMPRIMENTO]  SMALLMONEY    NULL,
    [LP_PRCPRD_ALTURA]       SMALLMONEY    NULL,
    [LP_PRCPRD_PROFUNDIDADE] SMALLMONEY    NULL,
    [PRECOFAB]               SMALLMONEY    NULL,
    [PRECOFABADC]            SMALLMONEY    NULL,
    [PRECOFABADCCMP]         SMALLMONEY    NULL,
    [PRECOFABADCALT]         SMALLMONEY    NULL,
    [PRECOFABADCPRF]         SMALLMONEY    NULL
);

