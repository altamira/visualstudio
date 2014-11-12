CREATE TABLE [dbo].[LAORVEMLENV] (
    [Lo0Emp]             CHAR (2)       NOT NULL,
    [Lo0PED]             INT            NOT NULL,
    [Lo2EmlEnvSeq]       SMALLINT       NOT NULL,
    [Lo2EmlEnvUsu]       CHAR (20)      NULL,
    [Lo2EmlEnvDat]       DATETIME       NULL,
    [Lo2EmlEnvDtH]       DATETIME       NULL,
    [Lo2EmlEnvPara]      VARCHAR (700)  NULL,
    [Lo2EmlEnvCopia]     VARCHAR (700)  NULL,
    [Lo2EmlEnvCopiaCega] VARCHAR (700)  NULL,
    [Lo2EmlEnvAss]       VARCHAR (700)  NULL,
    [Lo2EmlEnvAttach]    VARCHAR (2000) NULL,
    [Lo2EmlEnvTxt]       VARCHAR (2000) NULL,
    [Lo2EmlEnvRev]       CHAR (3)       NULL,
    PRIMARY KEY CLUSTERED ([Lo0Emp] ASC, [Lo0PED] ASC, [Lo2EmlEnvSeq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ULAORVEMLENV_A]
    ON [dbo].[LAORVEMLENV]([Lo0Emp] ASC, [Lo0PED] ASC, [Lo2EmlEnvSeq] DESC);


GO
CREATE NONCLUSTERED INDEX [ULAOVEMLENV_B]
    ON [dbo].[LAORVEMLENV]([Lo0Emp] ASC, [Lo0PED] ASC, [Lo2EmlEnvRev] ASC, [Lo2EmlEnvSeq] DESC);

