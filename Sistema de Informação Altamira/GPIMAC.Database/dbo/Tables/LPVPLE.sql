﻿CREATE TABLE [dbo].[LPVPLE] (
    [LPEMP]           CHAR (2)       NOT NULL,
    [LPPED]           INT            NOT NULL,
    [LpPle3SInCod]    CHAR (8)       NOT NULL,
    [LpPle3Seq]       SMALLINT       NOT NULL,
    [LpPle3DtE]       DATETIME       NULL,
    [LpPle3Pes]       MONEY          NULL,
    [LpPle3AcaCod]    CHAR (10)      NULL,
    [LpPle3Obs]       VARCHAR (1000) NULL,
    [LpPle3DtEAno]    SMALLINT       NULL,
    [LpPle3DtEMes]    SMALLINT       NULL,
    [LpPle3DtEAnoMes] INT            NULL,
    [LpPle3DtESem]    SMALLINT       NULL,
    [LpPle3DtEAnoSem] INT            NULL,
    [LpPle3Vei0Cod]   INT            NULL,
    PRIMARY KEY CLUSTERED ([LPEMP] ASC, [LPPED] ASC, [LpPle3SInCod] ASC, [LpPle3Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ULPVPLEA]
    ON [dbo].[LPVPLE]([LPEMP] ASC, [LPPED] ASC, [LpPle3SInCod] ASC, [LpPle3Seq] DESC);


GO
CREATE NONCLUSTERED INDEX [ILPVPLEB]
    ON [dbo].[LPVPLE]([LpPle3AcaCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPVPLEB]
    ON [dbo].[LPVPLE]([LPEMP] ASC, [LPPED] ASC, [LpPle3SInCod] ASC, [LpPle3DtE] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPVPLEC]
    ON [dbo].[LPVPLE]([LPEMP] ASC, [LPPED] ASC, [LpPle3SInCod] ASC, [LpPle3DtE] DESC);


GO
CREATE NONCLUSTERED INDEX [ULPVPLED]
    ON [dbo].[LPVPLE]([LPEMP] ASC, [LPPED] ASC, [LpPle3SInCod] ASC, [LpPle3DtEAnoMes] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPVPLEE]
    ON [dbo].[LPVPLE]([LPEMP] ASC, [LPPED] ASC, [LpPle3SInCod] ASC, [LpPle3DtEAnoMes] DESC);


GO
CREATE NONCLUSTERED INDEX [ILPVPLED]
    ON [dbo].[LPVPLE]([LpPle3SInCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPVPLEF]
    ON [dbo].[LPVPLE]([LPEMP] ASC, [LpPle3SInCod] ASC, [LpPle3DtE] ASC, [LPPED] ASC);


GO
CREATE NONCLUSTERED INDEX [ILPVPLEE]
    ON [dbo].[LPVPLE]([LpPle3Vei0Cod] ASC);

