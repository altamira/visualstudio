CREATE TABLE [dbo].[LARIRORDFAB] (
    [OrdEmp]   CHAR (2)  NOT NULL,
    [OrdCod]   INT       NOT NULL,
    [LRirCod]  INT       NOT NULL,
    [LRirEmp]  CHAR (2)  NOT NULL,
    [LOFRIQ]   INT       NULL,
    [LrirForn] CHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([OrdEmp] ASC, [OrdCod] ASC, [LRirCod] ASC, [LRirEmp] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILARIRORDFABB]
    ON [dbo].[LARIRORDFAB]([LRirCod] ASC, [LRirEmp] ASC);


GO
CREATE NONCLUSTERED INDEX [ULARIRORDFABA]
    ON [dbo].[LARIRORDFAB]([OrdCod] ASC, [LRirCod] ASC);

