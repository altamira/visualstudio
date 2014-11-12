CREATE TABLE [dbo].[ENVMTBFRET] (
    [EMBEmp]        CHAR (2)        NOT NULL,
    [EMBCodEnv]     INT             NOT NULL,
    [EMB2Seq]       SMALLINT        NOT NULL,
    [EMBRet3Ori]    CHAR (2)        NOT NULL,
    [EMBRet3OriEmp] CHAR (2)        NOT NULL,
    [EMBRet3OriNum] INT             NOT NULL,
    [EMBRet3OriTip] CHAR (1)        NOT NULL,
    [EMBRet3OriSeq] SMALLINT        NOT NULL,
    [EMBRet3DtR]    DATETIME        NOT NULL,
    [EMBRet3Qtd]    DECIMAL (11, 4) NOT NULL,
    PRIMARY KEY CLUSTERED ([EMBEmp] ASC, [EMBCodEnv] ASC, [EMB2Seq] ASC, [EMBRet3Ori] ASC, [EMBRet3OriEmp] ASC, [EMBRet3OriNum] ASC, [EMBRet3OriTip] ASC, [EMBRet3OriSeq] ASC)
);

