CREATE TABLE [dbo].[CONDOC] (
    [DocEmp]    CHAR (2)        NOT NULL,
    [DocTipCod] SMALLINT        NOT NULL,
    [DocCod]    INT             NOT NULL,
    [DocTit]    CHAR (60)       NULL,
    [DocObs]    VARCHAR (MAX)   NULL,
    [DocBlo]    VARBINARY (MAX) NULL,
    [DocVer]    CHAR (10)       NULL,
    [DocArqExt] CHAR (4)        NULL,
    [DocDat]    DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([DocEmp] ASC, [DocTipCod] ASC, [DocCod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ICONDOC1]
    ON [dbo].[CONDOC]([DocTipCod] ASC);

