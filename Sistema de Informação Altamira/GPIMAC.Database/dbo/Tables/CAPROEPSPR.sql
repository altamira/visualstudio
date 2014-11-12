CREATE TABLE [dbo].[CAPROEPSPR] (
    [CPROCOD]       CHAR (60)       NOT NULL,
    [CPRO1EP]       CHAR (2)        NOT NULL,
    [CPBCod]        CHAR (60)       NOT NULL,
    [CPBQtd]        DECIMAL (11, 4) NULL,
    [CPRO1EPSPrOrd] SMALLINT        NULL,
    [CPBSeq]        CHAR (1)        NULL,
    [CPBCorCod]     CHAR (10)       NULL,
    [CPBLrcGerSeq]  SMALLINT        NULL,
    [CPBLrcGerNum]  INT             NULL,
    [CPBLrcGerEmp]  CHAR (2)        NULL,
    [CPBLrcGer]     CHAR (1)        NULL,
    PRIMARY KEY CLUSTERED ([CPROCOD] ASC, [CPRO1EP] ASC, [CPBCod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ICAPROEPSPR]
    ON [dbo].[CAPROEPSPR]([CPBCorCod] ASC);

