CREATE TABLE [dbo].[CAMPR] (
    [CMPCOD]       CHAR (60)       NOT NULL,
    [CMPNOM]       CHAR (50)       NULL,
    [CMPCUS]       DECIMAL (13, 4) NULL,
    [CMPCLFCOD]    CHAR (5)        NULL,
    [CMPPesBru]    MONEY           NULL,
    [CMPPesLiq]    MONEY           NULL,
    [CMPEstMin]    MONEY           NULL,
    [CMPICMS]      SMALLMONEY      NULL,
    [CMPIPI]       SMALLMONEY      NULL,
    [CMPLENum]     CHAR (5)        NULL,
    [CMPLECrr]     CHAR (5)        NULL,
    [CMPLEPtr]     CHAR (5)        NULL,
    [CMPLEEst]     CHAR (5)        NULL,
    [CMPLECxa]     CHAR (5)        NULL,
    [CMPLEObs]     CHAR (200)      NULL,
    [CMPUNI]       CHAR (2)        NULL,
    [CmpEstIntFra] CHAR (1)        NULL,
    PRIMARY KEY CLUSTERED ([CMPCOD] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCAMPRA]
    ON [dbo].[CAMPR]([CMPNOM] ASC);


GO
CREATE NONCLUSTERED INDEX [ICAMPR]
    ON [dbo].[CAMPR]([CMPCLFCOD] ASC);

