CREATE TABLE [dbo].[ENVMTBF1] (
    [EMBEmp]        CHAR (2)        NOT NULL,
    [EMBCodEnv]     INT             NOT NULL,
    [EMB2Seq]       SMALLINT        NOT NULL,
    [EMBProdCodRet] CHAR (60)       NULL,
    [EMBSExCod]     CHAR (7)        NULL,
    [EMBCusSer]     DECIMAL (13, 4) NULL,
    [EMB2QtdPRet]   DECIMAL (11, 4) NULL,
    [EMBGer]        CHAR (1)        NULL,
    [EMB2QtdeCan]   DECIMAL (11, 4) NULL,
    [EMB2DtEnt]     DATETIME        NULL,
    [EMB2SaldoRed]  DECIMAL (11, 4) NULL,
    [EMB2NotaRet]   INT             NULL,
    [EMB2DtRet]     DATETIME        NULL,
    [EMB2Obs1]      CHAR (80)       NULL,
    [EMB2Obs2]      CHAR (80)       NULL,
    [EMBOrdCod]     INT             NULL,
    PRIMARY KEY CLUSTERED ([EMBEmp] ASC, [EMBCodEnv] ASC, [EMB2Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UENVMTBF1A]
    ON [dbo].[ENVMTBF1]([EMBEmp] ASC, [EMBCodEnv] ASC, [EMB2Seq] DESC);


GO
CREATE NONCLUSTERED INDEX [UENVMTBF1B]
    ON [dbo].[ENVMTBF1]([EMBEmp] ASC, [EMBCodEnv] ASC, [EMBProdCodRet] ASC, [EMBSExCod] ASC);

