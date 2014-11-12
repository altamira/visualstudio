CREATE TABLE [dbo].[LAESPNF1] (
    [NOTEMP]       CHAR (2)        NOT NULL,
    [NOTNUM]       INT             NOT NULL,
    [NOTTip]       CHAR (1)        NOT NULL,
    [NO1SEQ]       SMALLINT        NOT NULL,
    [NO1COD]       CHAR (60)       NULL,
    [NO1NOM]       CHAR (120)      NULL,
    [NO1CLA]       CHAR (5)        NULL,
    [NO1UNI]       CHAR (2)        NULL,
    [NO1QUA]       DECIMAL (11, 4) NULL,
    [NO1PUN]       DECIMAL (13, 4) NULL,
    [NO1PLQ]       MONEY           NULL,
    [NO1PBR]       MONEY           NULL,
    [NO1MER]       MONEY           NULL,
    [NO1BASICM]    MONEY           NULL,
    [NO1PEICM]     SMALLMONEY      NULL,
    [NO1PEIPI]     SMALLMONEY      NULL,
    [NO1ICM]       MONEY           NULL,
    [NO1IPI]       MONEY           NULL,
    [NO1TOT]       MONEY           NULL,
    [NO1OBS]       CHAR (80)       NULL,
    [NO1OB1]       CHAR (80)       NULL,
    [NO1OB2]       CHAR (80)       NULL,
    [NO1OB3]       CHAR (80)       NULL,
    [NO1OB4]       CHAR (80)       NULL,
    [NO1CLI]       CHAR (15)       NULL,
    [NO1PPE]       CHAR (20)       NULL,
    [NO1SITTRB]    CHAR (4)        NULL,
    [NO1MovEst]    INT             NULL,
    [NO1ValCom]    MONEY           NULL,
    [NO1REDICM]    SMALLMONEY      NULL,
    [NO1BASIPI]    MONEY           NULL,
    [NO1BASICST]   MONEY           NULL,
    [NO1ALIICMST]  SMALLMONEY      NULL,
    [NO1VALICST]   MONEY           NULL,
    [NO1TIP]       CHAR (2)        NULL,
    [NO1MRCICST]   SMALLMONEY      NULL,
    [NO1FRETOT]    MONEY           NULL,
    [No1CFOP]      CHAR (6)        NULL,
    [No1PisCST]    CHAR (2)        NULL,
    [No1PisBas]    MONEY           NULL,
    [No1PisAli]    SMALLMONEY      NULL,
    [No1PisTot]    MONEY           NULL,
    [No1CofCST]    CHAR (2)        NULL,
    [No1CofBas]    MONEY           NULL,
    [No1CofAli]    SMALLMONEY      NULL,
    [No1CofTot]    MONEY           NULL,
    [NO1EBnEnv]    CHAR (1)        NULL,
    [NO1EBnDtV]    DATETIME        NULL,
    [NO1EBnQtC]    DECIMAL (11, 4) NULL,
    [NO1EBnSalRed] DECIMAL (11, 4) NULL,
    [No1DesDet]    VARCHAR (2000)  NULL,
    [NO1SEGVAL]    MONEY           NULL,
    [NO1OUTDESACE] MONEY           NULL,
    CONSTRAINT [PK__LAESPNF1__E093C4E36FD49106] PRIMARY KEY CLUSTERED ([NOTEMP] ASC, [NOTNUM] ASC, [NOTTip] ASC, [NO1SEQ] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ULAEPSNF1A]
    ON [dbo].[LAESPNF1]([NO1COD] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAESPNF1A]
    ON [dbo].[LAESPNF1]([NO1CLA] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAESPNF1B]
    ON [dbo].[LAESPNF1]([NO1MovEst] ASC, [NO1COD] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAESPNF1C]
    ON [dbo].[LAESPNF1]([NOTEMP] ASC, [NOTNUM] ASC, [NOTTip] ASC, [NO1CLA] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAESPNF1D]
    ON [dbo].[LAESPNF1]([NOTEMP] ASC, [NOTNUM] ASC, [NOTTip] ASC, [NO1CLI] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAESPNF1E]
    ON [dbo].[LAESPNF1]([No1CFOP] ASC);

