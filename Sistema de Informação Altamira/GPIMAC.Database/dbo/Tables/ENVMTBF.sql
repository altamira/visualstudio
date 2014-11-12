CREATE TABLE [dbo].[ENVMTBF] (
    [EMBEmp]        CHAR (2)       NOT NULL,
    [EMBCodEnv]     INT            NOT NULL,
    [EMB0Usu]       CHAR (20)      NULL,
    [EMBDtC]        DATETIME       NULL,
    [EMBDat]        DATETIME       NULL,
    [EMBDEnt]       DATETIME       NULL,
    [EMBTbpForCNPJ] CHAR (18)      NULL,
    [EMBTbpCod]     CHAR (7)       NULL,
    [EMBRefPed]     INT            NULL,
    [EMBObs01]      VARCHAR (2000) NULL,
    [EMB0Ger]       CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([EMBEmp] ASC, [EMBCodEnv] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IENVMTBF]
    ON [dbo].[ENVMTBF]([EMBTbpForCNPJ] ASC, [EMBTbpCod] ASC);

