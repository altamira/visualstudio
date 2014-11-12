CREATE TABLE [dbo].[CADIV] (
    [CDIVCOD]    CHAR (60)       NOT NULL,
    [CDIVNOM]    CHAR (50)       NULL,
    [CDIVUNI]    CHAR (2)        NULL,
    [CDIVEST]    CHAR (3)        NULL,
    [CDIVPRA]    CHAR (3)        NULL,
    [CDIVSAC]    CHAR (3)        NULL,
    [CDIVOBS]    CHAR (40)       NULL,
    [CDIVVAL]    DECIMAL (13, 4) NULL,
    [CDIVMIN]    INT             NULL,
    [CDIVSAL]    CHAR (3)        NULL,
    [CDIVDAT]    DATETIME        NULL,
    [CDIVFOR]    CHAR (30)       NULL,
    [CDIVCLFCOD] CHAR (5)        NULL,
    [CDIVPesBru] MONEY           NULL,
    [CDIVPesLiq] MONEY           NULL,
    [CDIVICMS]   SMALLMONEY      NULL,
    [CDIVIPI]    SMALLMONEY      NULL,
    [CDIVCorr]   CHAR (3)        NULL,
    [CDivObsEst] CHAR (200)      NULL,
    [CDIVGerRir] CHAR (1)        NULL,
    PRIMARY KEY CLUSTERED ([CDIVCOD] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCADIVA]
    ON [dbo].[CADIV]([CDIVNOM] ASC);


GO
CREATE NONCLUSTERED INDEX [ICADIV]
    ON [dbo].[CADIV]([CDIVCLFCOD] ASC);

