CREATE TABLE [dbo].[LARIRRETBEM] (
    [LRirEmp]  CHAR (2)        NOT NULL,
    [LRirCod]  INT             NOT NULL,
    [Lrir2Seq] SMALLINT        NOT NULL,
    [Lrir2Qtd] DECIMAL (11, 4) NULL,
    [Lrir2Emp] CHAR (2)        NULL,
    [LRir2NF]  INT             NULL,
    [LRir2Tip] CHAR (1)        NULL,
    [LRir2Ite] SMALLINT        NULL,
    [Lrir2Ori] CHAR (2)        NULL,
    [Lrir2Obs] CHAR (100)      NULL,
    PRIMARY KEY CLUSTERED ([LRirEmp] ASC, [LRirCod] ASC, [Lrir2Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILARIRLEVEL21]
    ON [dbo].[LARIRRETBEM]([LRirCod] ASC, [LRirEmp] ASC);


GO
CREATE NONCLUSTERED INDEX [ULARIRRETBENA]
    ON [dbo].[LARIRRETBEM]([LRirEmp] ASC, [LRirCod] ASC, [Lrir2Seq] DESC);

