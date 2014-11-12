CREATE TABLE [dbo].[ORDFABLAN] (
    [OrdEmp]               CHAR (2)        NOT NULL,
    [OrdCod]               INT             NOT NULL,
    [OrdPri]               CHAR (1)        NULL,
    [CCCGC]                CHAR (18)       NULL,
    [UltOrdCmp]            INT             NULL,
    [Ordpecli]             INT             NULL,
    [Ordentr]              DATETIME        NULL,
    [ordopatu]             INT             NULL,
    [ordsertu]             CHAR (3)        NULL,
    [ordreatu]             DECIMAL (11, 4) NULL,
    [OrdBaixa]             DECIMAL (11, 4) NULL,
    [CPROCOD]              CHAR (60)       NULL,
    [OrdQtd]               DECIMAL (11, 4) NULL,
    [OrdImpr]              CHAR (1)        NULL,
    [OrdpecliTip]          CHAR (2)        NULL,
    [OrdpecliEmp]          CHAR (2)        NULL,
    [OrdpecliIt]           SMALLINT        NULL,
    [OrdObs]               VARCHAR (1000)  NULL,
    [ordini]               DATETIME        NULL,
    [ORDDI]                DATETIME        NULL,
    [ORDCLI]               CHAR (15)       NULL,
    [ORITEM]               CHAR (6)        NULL,
    [OrdCorR]              SMALLINT        NULL,
    [OrdCorG]              SMALLINT        NULL,
    [OrdCorB]              SMALLINT        NULL,
    [OrdCodPai]            INT             NULL,
    [CPRO1EP]              CHAR (2)        NULL,
    [OrdMovTrn]            INT             NULL,
    [OrdDtBai]             DATETIME        NULL,
    [OrdOPRaiz]            INT             NULL,
    [OrdBai]               CHAR (1)        NULL,
    [OrdBaiLibRed]         CHAR (1)        NULL,
    [OrdOPRaizOri]         CHAR (2)        NULL,
    [OrdOPRaizOriNum]      INT             NULL,
    [OrdOPRaizOriIt]       SMALLINT        NULL,
    [ORDDHI]               DATETIME        NULL,
    [OrdUsu]               CHAR (20)       NULL,
    [OrdCorDesRed]         CHAR (10)       NULL,
    [OrdPeCliLib]          CHAR (1)        NULL,
    [OrdPeCliBlockCod]     SMALLINT        NULL,
    [OrdPeCliBlock]        CHAR (1)        NULL,
    [OrdLPWBCCADSGRCODRed] INT             NULL,
    [OrdLPWBCCADGRPCODRed] INT             NULL,
    [OrdLPWBCCADORCITMRed] SMALLINT        NULL,
    [OrdLPWBCCADORCNUMRed] CHAR (8)        NULL,
    PRIMARY KEY CLUSTERED ([OrdEmp] ASC, [OrdCod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IORDFABLANB]
    ON [dbo].[ORDFABLAN]([CCCGC] ASC);


GO
CREATE NONCLUSTERED INDEX [UORDFABLANA]
    ON [dbo].[ORDFABLAN]([OrdCod] ASC, [Ordpecli] ASC, [OrdpecliIt] ASC);


GO
CREATE NONCLUSTERED INDEX [UORDFABLANB]
    ON [dbo].[ORDFABLAN]([OrdpecliTip] ASC, [OrdpecliEmp] ASC, [Ordpecli] ASC, [OrdpecliIt] ASC);


GO
CREATE NONCLUSTERED INDEX [UORDFABLANC]
    ON [dbo].[ORDFABLAN]([Ordentr] ASC);


GO
CREATE NONCLUSTERED INDEX [UORDFABLAND]
    ON [dbo].[ORDFABLAN]([ordsertu] ASC);


GO
CREATE NONCLUSTERED INDEX [IORDFABLANC]
    ON [dbo].[ORDFABLAN]([CPROCOD] ASC, [CPRO1EP] ASC);


GO
CREATE NONCLUSTERED INDEX [UORDFABLANE]
    ON [dbo].[ORDFABLAN]([OrdEmp] ASC, [CPROCOD] ASC);

