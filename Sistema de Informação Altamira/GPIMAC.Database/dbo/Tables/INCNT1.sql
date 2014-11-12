CREATE TABLE [dbo].[INCNT1] (
    [Cnt0Emp]      CHAR (2)        NOT NULL,
    [Cnt0Num]      INT             NOT NULL,
    [Cnt0Tip]      CHAR (1)        NOT NULL,
    [Cnt0EmiCnpj]  CHAR (18)       NOT NULL,
    [Cnt1Seq]      SMALLINT        NOT NULL,
    [Cnt1ProCod]   CHAR (60)       NULL,
    [Cnt1ProNom]   CHAR (53)       NULL,
    [Cnt1ProUni]   CHAR (6)        NULL,
    [Cnt1Qua]      DECIMAL (11, 4) NULL,
    [Cnt1PreUni]   DECIMAL (13, 4) NULL,
    [Cnt1ProTot]   MONEY           NULL,
    [Cnt1NCMCod]   CHAR (2)        NULL,
    [Cnt1NCM]      CHAR (10)       NULL,
    [Cnt1NCMDes]   CHAR (25)       NULL,
    [Cnt1ST]       CHAR (3)        NULL,
    [Cnt1IpiAli]   SMALLMONEY      NULL,
    [Cnt1IpiBas]   MONEY           NULL,
    [Cnt1IpiVal]   MONEY           NULL,
    [Cnt1IpiIse]   MONEY           NULL,
    [Cnt1IpiOut]   MONEY           NULL,
    [Cnt1Tot]      MONEY           NULL,
    [Cnt1IcmAli]   SMALLMONEY      NULL,
    [Cnt1IcmBCRed] SMALLMONEY      NULL,
    [Cnt1IcmBas]   MONEY           NULL,
    [Cnt1IcmVal]   MONEY           NULL,
    [Cnt1IcmIse]   MONEY           NULL,
    [Cnt1IcmOut]   MONEY           NULL,
    [Cnt1Mod]      SMALLINT        NULL,
    [Cnt1BasSt]    MONEY           NULL,
    [Cnt1ValSt]    MONEY           NULL,
    PRIMARY KEY CLUSTERED ([Cnt0Emp] ASC, [Cnt0Num] ASC, [Cnt0Tip] ASC, [Cnt0EmiCnpj] ASC, [Cnt1Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UINCNT1A]
    ON [dbo].[INCNT1]([Cnt0Emp] ASC, [Cnt0Num] ASC, [Cnt0Tip] ASC, [Cnt0EmiCnpj] ASC, [Cnt1IcmAli] ASC);

