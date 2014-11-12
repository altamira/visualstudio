CREATE TABLE [dbo].[CBRD] (
    [CbRDat]    DATETIME      NOT NULL,
    [CbrSeq]    CHAR (2)      NOT NULL,
    [DUPTIP]    CHAR (2)      NOT NULL,
    [DUPNUM]    INT           NOT NULL,
    [DUPSEQ]    CHAR (1)      NOT NULL,
    [DUPTipNF]  CHAR (1)      NOT NULL,
    [CbrCbCod]  CHAR (3)      NULL,
    [CbrCmp1]   CHAR (11)     NULL,
    [CbrCmp2]   CHAR (12)     NULL,
    [CbrCmp3]   CHAR (12)     NULL,
    [CbrCmp4]   CHAR (1)      NULL,
    [CbrCmp5]   CHAR (14)     NULL,
    [CbrLocPgt] VARCHAR (100) NULL,
    [CbrDatVct] DATETIME      NULL,
    [CbrNomCed] CHAR (100)    NULL,
    [CbrCodCed] CHAR (18)     NULL,
    [CbrIdCed]  CHAR (30)     NULL,
    [CbrDatEm]  DATETIME      NULL,
    [CbrNumDoc] CHAR (30)     NULL,
    [CbrEsp]    CHAR (30)     NULL,
    [CbAce]     CHAR (1)      NULL,
    [CbrDatPro] DATETIME      NULL,
    [CbrnumBco] CHAR (30)     NULL,
    [CbrVal]    MONEY         NULL,
    [CbrDesc]   MONEY         NULL,
    [CbrObs1]   CHAR (100)    NULL,
    [CbrObs2]   CHAR (100)    NULL,
    [CbrObs3]   CHAR (100)    NULL,
    [CbrObs4]   CHAR (100)    NULL,
    [CbrObs5]   CHAR (100)    NULL,
    [CbrObs6]   CHAR (100)    NULL,
    [CbrObs7]   CHAR (100)    NULL,
    [CbrNomSac] CHAR (100)    NULL,
    [CbrendSac] CHAR (100)    NULL,
    [CbrCidSac] CHAR (100)    NULL,
    [CbrCodBar] CHAR (44)     NULL,
    [CbrUsoBnc] CHAR (15)     NULL,
    PRIMARY KEY CLUSTERED ([CbRDat] ASC, [CbrSeq] ASC, [DUPTIP] ASC, [DUPNUM] ASC, [DUPSEQ] ASC, [DUPTipNF] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ICBRD1]
    ON [dbo].[CBRD]([DUPTIP] ASC, [DUPNUM] ASC, [DUPSEQ] ASC, [DUPTipNF] ASC);

