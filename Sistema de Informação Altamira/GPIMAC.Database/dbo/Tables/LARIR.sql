CREATE TABLE [dbo].[LARIR] (
    [LRirCod]       INT             NOT NULL,
    [LRirEmp]       CHAR (2)        NOT NULL,
    [LRirCon]       CHAR (1)        NULL,
    [LRirImp]       CHAR (1)        NULL,
    [LRirObs]       VARCHAR (5000)  NULL,
    [LRirNFNum]     INT             NULL,
    [CCCGC]         CHAR (18)       NULL,
    [LRirDat]       DATETIME        NULL,
    [LRirPed]       INT             NULL,
    [LRirQua]       DECIMAL (11, 4) NULL,
    [LRirSai]       DECIMAL (11, 4) NULL,
    [LRirNFOb1]     CHAR (100)      NULL,
    [LRirFor]       CHAR (50)       NULL,
    [LRirPCod]      CHAR (60)       NULL,
    [LRirPNom]      CHAR (120)      NULL,
    [LrirPun]       CHAR (2)        NULL,
    [LRirNFOb2]     CHAR (100)      NULL,
    [LRirCert]      CHAR (30)       NULL,
    [LRirTip]       CHAR (2)        NULL,
    [LRirBaiBen]    DECIMAL (11, 4) NULL,
    [LRirBaiOP]     DECIMAL (11, 4) NULL,
    [LRirNFSeq]     SMALLINT        NULL,
    [LRirNFOri]     CHAR (2)        NULL,
    [LRirNFIte]     SMALLINT        NULL,
    [LRirSalRed]    DECIMAL (11, 4) NULL,
    [LRirResRed]    DECIMAL (11, 4) NULL,
    [LRirSalDisRed] DECIMAL (11, 4) NULL,
    [LRirMovLan]    INT             NULL,
    PRIMARY KEY CLUSTERED ([LRirCod] ASC, [LRirEmp] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILARIRB]
    ON [dbo].[LARIR]([CCCGC] ASC);


GO
CREATE NONCLUSTERED INDEX [ULARIRA]
    ON [dbo].[LARIR]([LRirCod] ASC, [LRirDat] ASC);


GO
CREATE NONCLUSTERED INDEX [ULARIRB]
    ON [dbo].[LARIR]([LRirCod] ASC, [LRirDat] DESC);


GO
CREATE NONCLUSTERED INDEX [ULARIRRC]
    ON [dbo].[LARIR]([LRirPCod] ASC, [LRirDat] ASC);


GO
CREATE NONCLUSTERED INDEX [ULARIRD]
    ON [dbo].[LARIR]([LRirPCod] ASC, [LRirDat] DESC);


GO
CREATE NONCLUSTERED INDEX [ULARIRE]
    ON [dbo].[LARIR]([LRirEmp] ASC, [LRirCod] ASC);

