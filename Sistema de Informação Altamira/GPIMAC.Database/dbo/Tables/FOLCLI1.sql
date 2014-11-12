CREATE TABLE [dbo].[FOLCLI1] (
    [FCCnpj] CHAR (18)  NOT NULL,
    [FCSeq]  INT        NOT NULL,
    [FCDat]  DATETIME   NULL,
    [FCHor]  CHAR (8)   NULL,
    [FCCon]  CHAR (30)  NULL,
    [FCFal]  CHAR (30)  NULL,
    [FCAss]  CHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([FCCnpj] ASC, [FCSeq] ASC)
);

