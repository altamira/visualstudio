CREATE TABLE [dbo].[LAESPNF] (
    [NOTEMP]       CHAR (2)       NOT NULL,
    [NOTNUM]       INT            NOT NULL,
    [NOTTip]       CHAR (1)       NOT NULL,
    [CCCGC]        CHAR (18)      NULL,
    [COCOD]        CHAR (6)       NULL,
    [NOTPV0]       INT            NULL,
    [NOTSPE]       CHAR (18)      NULL,
    [NOTPC0]       SMALLMONEY     NULL,
    [NOTDATPED]    DATETIME       NULL,
    [NOTDATSAI]    DATETIME       NULL,
    [NOTCON]       CHAR (20)      NULL,
    [NOTFRE]       CHAR (1)       NULL,
    [NOTMOE]       CHAR (1)       NULL,
    [NOTMAR]       CHAR (50)      NULL,
    [NOTVOL]       CHAR (50)      NULL,
    [NOTQVO]       INT            NULL,
    [NOTESP]       CHAR (20)      NULL,
    [NOTPLQ]       MONEY          NULL,
    [NOTPBR]       MONEY          NULL,
    [NOTDATEMI]    DATETIME       NULL,
    [NOTVALTOT]    MONEY          NULL,
    [NOTBASICM]    MONEY          NULL,
    [NOTPERICM]    SMALLMONEY     NULL,
    [NOTVALICM]    MONEY          NULL,
    [NOTTOTPRO]    MONEY          NULL,
    [NOTVALIPI]    MONEY          NULL,
    [NOTVALCOM]    MONEY          NULL,
    [NOTIMP]       CHAR (1)       NULL,
    [CACODI]       SMALLINT       NULL,
    [NOTVALSUF]    MONEY          NULL,
    [NOTOF]        INT            NULL,
    [NOTEST]       CHAR (1)       NULL,
    [NOTELI]       CHAR (1)       NULL,
    [NOTBAS1]      MONEY          NULL,
    [NOTVFRE]      MONEY          NULL,
    [NOTPERIPI]    SMALLMONEY     NULL,
    [NOTVEN]       CHAR (3)       NULL,
    [NOTCPAG]      CHAR (3)       NULL,
    [NOTTRAC]      CHAR (5)       NULL,
    [NOTENT]       CHAR (1)       NULL,
    [NOTSIPI]      MONEY          NULL,
    [NOTCECOD]     CHAR (2)       NULL,
    [NOTTIPVEN]    SMALLINT       NULL,
    [NOTEMPCOD]    CHAR (2)       NULL,
    [NOTBASIPI]    MONEY          NULL,
    [NOTNFeNum]    INT            NULL,
    [NOTNFeSer]    SMALLINT       NULL,
    [NOTNFeChA]    CHAR (44)      NULL,
    [NOTCPrS0Cod]  INT            NULL,
    [NOTISSAli]    SMALLMONEY     NULL,
    [NOTISSRet]    SMALLINT       NULL,
    [NOTRPSSit]    CHAR (1)       NULL,
    [NOTTotSer]    MONEY          NULL,
    [NOTTotDed]    MONEY          NULL,
    [NotTotISS]    MONEY          NULL,
    [NotRPSDes]    VARCHAR (500)  NULL,
    [NOTPrSDes]    CHAR (30)      NULL,
    [NotNFeEnv]    CHAR (1)       NULL,
    [NotNFeRec]    CHAR (1)       NULL,
    [NotNFeCodVer] CHAR (20)      NULL,
    [NotNFeDtHGer] DATETIME       NULL,
    [NOTRESSAI]    CHAR (50)      NULL,
    [NOTUSUSAI]    CHAR (20)      NULL,
    [NOTDTHSAI]    DATETIME       NULL,
    [NOTDATCAN]    DATETIME       NULL,
    [NOTRESCAN]    CHAR (50)      NULL,
    [NOTUSUCAN]    CHAR (20)      NULL,
    [NOTDTHCAN]    DATETIME       NULL,
    [NotObs]       VARCHAR (2000) NULL,
    [NOTNumOri]    INT            NULL,
    [NOTVALSEG]    MONEY          NULL,
    [NOTVALACE]    MONEY          NULL,
    [NOTBASICMSTR] MONEY          NULL,
    [NOTVALICMSTR] MONEY          NULL,
    [NOTVALPIS]    MONEY          NULL,
    [NOTVALCOF]    MONEY          NULL,
    [NOTComTip]    CHAR (1)       NULL,
    [CCEnd1Seq]    SMALLINT       NULL,
    PRIMARY KEY CLUSTERED ([NOTEMP] ASC, [NOTNUM] ASC, [NOTTip] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILAESPNFB]
    ON [dbo].[LAESPNF]([NOTEMPCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAESPNFC]
    ON [dbo].[LAESPNF]([NOTCECOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAESPNFD]
    ON [dbo].[LAESPNF]([NOTTRAC] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAESPNFE]
    ON [dbo].[LAESPNF]([NOTCPAG] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAESPNFF]
    ON [dbo].[LAESPNF]([NOTVEN] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAESPNFG]
    ON [dbo].[LAESPNF]([CACODI] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAESPNFH]
    ON [dbo].[LAESPNF]([COCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAESPNFA]
    ON [dbo].[LAESPNF]([NOTDATEMI] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAESPNFB]
    ON [dbo].[LAESPNF]([NOTDATEMI] DESC);


GO
CREATE NONCLUSTERED INDEX [ULAESPNFC]
    ON [dbo].[LAESPNF]([NOTNUM] DESC);


GO
CREATE NONCLUSTERED INDEX [ULAESPNFD]
    ON [dbo].[LAESPNF]([CCCGC] ASC, [NOTNUM] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAESPNFE]
    ON [dbo].[LAESPNF]([CCCGC] ASC, [NOTNUM] DESC, [CACODI] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAESPNFJ]
    ON [dbo].[LAESPNF]([NOTCPrS0Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAESPNFF]
    ON [dbo].[LAESPNF]([NOTEMP] ASC, [NOTNUM] DESC);


GO
CREATE NONCLUSTERED INDEX [ULAESPNFG]
    ON [dbo].[LAESPNF]([NOTEMP] ASC, [NOTNumOri] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAESPNF]
    ON [dbo].[LAESPNF]([CCCGC] ASC, [CCEnd1Seq] ASC);

