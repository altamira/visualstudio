CREATE TABLE [dbo].[NFE3COBNFEDUP] (
    [NFe0Emp]           CHAR (2)  NOT NULL,
    [NFe0FatNum]        INT       NOT NULL,
    [NFe0FatTip]        CHAR (1)  NOT NULL,
    [NFe0FatCnpjCpfEmi] CHAR (14) NOT NULL,
    [NFe3Seq]           SMALLINT  NOT NULL,
    [NFe3_dup_nDup]     CHAR (60) NOT NULL,
    [NFe3_dup_dVenc]    DATETIME  NOT NULL,
    [NFe3_dup_vDup]     MONEY     NOT NULL,
    PRIMARY KEY CLUSTERED ([NFe0Emp] ASC, [NFe0FatNum] ASC, [NFe0FatTip] ASC, [NFe0FatCnpjCpfEmi] ASC, [NFe3Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UNFE3COBNFEDUPA]
    ON [dbo].[NFE3COBNFEDUP]([NFe0Emp] ASC, [NFe0FatNum] ASC, [NFe0FatTip] ASC, [NFe0FatCnpjCpfEmi] ASC, [NFe3Seq] DESC);

