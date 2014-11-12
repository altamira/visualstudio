CREATE TABLE [dbo].[ORDFABLANLEVEL4] (
    [OrdEmp]        CHAR (2)        NOT NULL,
    [OrdCod]        INT             NOT NULL,
    [CPSSeq]        SMALLINT        NOT NULL,
    [ordliq]        SMALLMONEY      NULL,
    [ordob1]        CHAR (96)       NULL,
    [ORDCODC]       CHAR (20)       NULL,
    [ORDOB2]        CHAR (96)       NULL,
    [OrdEmpenho]    DECIMAL (11, 4) NULL,
    [OrdQtdRea]     DECIMAL (11, 4) NULL,
    [OrdQtdSal]     DECIMAL (11, 4) NULL,
    [OrdBrut]       DECIMAL (11, 4) NULL,
    [ordmaq]        CHAR (3)        NULL,
    [OrdCProTemSet] INT             NULL,
    PRIMARY KEY CLUSTERED ([OrdEmp] ASC, [OrdCod] ASC, [CPSSeq] ASC)
);

