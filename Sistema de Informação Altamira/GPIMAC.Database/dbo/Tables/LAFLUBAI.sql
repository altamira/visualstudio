CREATE TABLE [dbo].[LAFLUBAI] (
    [LFLUREG]           INT            NOT NULL,
    [LFluBai1Seq]       SMALLINT       NOT NULL,
    [LFluBai1Dat]       DATETIME       NULL,
    [LFluBai1ValDes]    MONEY          NULL,
    [LFluBai1ValJur]    MONEY          NULL,
    [LFluBai1Val]       MONEY          NULL,
    [LFluBai1UsuCri]    CHAR (20)      NULL,
    [LFluBai1DtHCri]    DATETIME       NULL,
    [LFluBai1UsuAlt]    CHAR (20)      NULL,
    [LFluBai1DtHAlt]    DATETIME       NULL,
    [CBACOD]            CHAR (3)       NULL,
    [LFLUNCH]           CHAR (12)      NULL,
    [LFLUCHE]           CHAR (30)      NULL,
    [LFLUDCHE]          DATETIME       NULL,
    [LFLUICH]           CHAR (1)       NULL,
    [LFLuFecDat]        DATETIME       NULL,
    [LFluCheCmp]        CHAR (1)       NULL,
    [LFluOrd]           INT            NULL,
    [LFluBai1FPCod]     CHAR (5)       NULL,
    [LfluBai1DtaBor]    DATETIME       NULL,
    [LFluBai1ComFluGer] INT            NULL,
    [LFluBai1ComModUsu] CHAR (20)      NULL,
    [LFluBai1ComModDtH] DATETIME       NULL,
    [LFluBai1ComObs]    VARCHAR (1000) NULL,
    [LFluBai1ComPor]    SMALLMONEY     NULL,
    [LFluBai1ComValAbt] MONEY          NULL,
    [LFluBai1ComBai]    CHAR (1)       NULL,
    [LFluBai1ComDtPgC]  DATETIME       NULL,
    [LFluBai1ComDtPrP]  DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([LFLUREG] ASC, [LFluBai1Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILAFLUBAIC]
    ON [dbo].[LAFLUBAI]([CBACOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUBAIA]
    ON [dbo].[LAFLUBAI]([LFLUREG] ASC, [LFluBai1Seq] DESC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUBAIB]
    ON [dbo].[LAFLUBAI]([LFLUREG] ASC, [LFluBai1Dat] DESC, [LFluBai1Seq] DESC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUBAIC]
    ON [dbo].[LAFLUBAI]([LFLUREG] ASC, [LFluBai1Dat] DESC, [LFluBai1Seq] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFLUBAI]
    ON [dbo].[LAFLUBAI]([LFluBai1FPCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFLUBAID]
    ON [dbo].[LAFLUBAI]([LFluBai1FPCod] ASC);

