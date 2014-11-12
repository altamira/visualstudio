CREATE TABLE [dbo].[LRPRO1] (
    [L1CCOD]    INT             NOT NULL,
    [L1CEMP]    CHAR (2)        NOT NULL,
    [L1cseq]    SMALLINT        NOT NULL,
    [CPROCOD]   CHAR (60)       NULL,
    [L1CQUA]    DECIMAL (11, 4) NULL,
    [L1COF]     INT             NULL,
    [L1RIR]     INT             NULL,
    [L1CMovLan] INT             NULL,
    [L1CPCIte]  SMALLINT        NULL,
    [L1CPCCod]  INT             NULL,
    [L1CQtdIte] DECIMAL (11, 4) NULL,
    PRIMARY KEY CLUSTERED ([L1CCOD] ASC, [L1CEMP] ASC, [L1cseq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILRPRO1B]
    ON [dbo].[LRPRO1]([CPROCOD] ASC);

