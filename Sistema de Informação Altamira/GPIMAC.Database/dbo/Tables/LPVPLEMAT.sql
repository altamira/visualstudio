CREATE TABLE [dbo].[LPVPLEMAT] (
    [LPEMP]        CHAR (2)        NOT NULL,
    [LPPED]        INT             NOT NULL,
    [LpPle3SInCod] CHAR (8)        NOT NULL,
    [LpPle3Seq]    SMALLINT        NOT NULL,
    [LpPlE4ProCod] CHAR (60)       NOT NULL,
    [LpPlE4Qtd]    DECIMAL (11, 4) NULL,
    PRIMARY KEY CLUSTERED ([LPEMP] ASC, [LPPED] ASC, [LpPle3SInCod] ASC, [LpPle3Seq] ASC, [LpPlE4ProCod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILPVPLEMATC]
    ON [dbo].[LPVPLEMAT]([LpPlE4ProCod] ASC);

