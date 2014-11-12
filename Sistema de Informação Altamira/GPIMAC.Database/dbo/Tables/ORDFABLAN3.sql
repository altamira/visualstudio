CREATE TABLE [dbo].[ORDFABLAN3] (
    [OrdEmp]            CHAR (2)        NOT NULL,
    [OrdCod]            INT             NOT NULL,
    [CPBCod]            CHAR (60)       NOT NULL,
    [OrdCPBQtd]         DECIMAL (11, 4) NULL,
    [ORDCPBUTI]         DECIMAL (11, 4) NULL,
    [ORDCPBGer]         CHAR (1)        NULL,
    [OrdCPBSeq]         CHAR (1)        NULL,
    [OrdCPbQtdOri]      DECIMAL (11, 4) NULL,
    [OrdCpbOPRomTemRed] CHAR (1)        NULL,
    [OrdCPbSalRed]      DECIMAL (11, 4) NULL,
    PRIMARY KEY CLUSTERED ([OrdEmp] ASC, [OrdCod] ASC, [CPBCod] ASC)
);

