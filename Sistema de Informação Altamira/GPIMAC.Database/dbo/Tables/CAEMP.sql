CREATE TABLE [dbo].[CAEMP] (
    [CEMPCOD]          CHAR (2)   NOT NULL,
    [CEMPNOM]          CHAR (30)  NULL,
    [CEMPCNPJ]         CHAR (18)  NULL,
    [CEMPIE]           CHAR (20)  NULL,
    [CEMPRAZSOC]       CHAR (50)  NULL,
    [CEMPEND]          CHAR (50)  NULL,
    [CEMPBAI]          CHAR (30)  NULL,
    [CEMPCEP]          CHAR (9)   NULL,
    [CEMPCID]          CHAR (30)  NULL,
    [CEMPCECOD]        CHAR (2)   NULL,
    [CEMPCabRep01]     CHAR (100) NULL,
    [CEMPCabRep02]     CHAR (100) NULL,
    [CEMPCabRep03]     CHAR (100) NULL,
    [CEMPCabRep04]     CHAR (100) NULL,
    [CEmpIPI]          CHAR (1)   NULL,
    [CEmpUltFatMer]    INT        NULL,
    [CEmpUltFatSer]    INT        NULL,
    [CEmpICM]          CHAR (1)   NULL,
    [CEmpICST]         CHAR (1)   NULL,
    [CEMPENDLOG]       CHAR (3)   NOT NULL,
    [CEMPENDNUM]       CHAR (10)  NOT NULL,
    [CEMPENDCPL]       CHAR (30)  NOT NULL,
    [CEMPIEST]         CHAR (20)  NOT NULL,
    [CEMPCCM]          CHAR (15)  NOT NULL,
    [CEMPTELDDD]       CHAR (5)   NOT NULL,
    [CEMPTELNUM]       CHAR (9)   NOT NULL,
    [CEMPTELRAM]       CHAR (5)   NOT NULL,
    [CEMPFAXDDD]       CHAR (5)   NOT NULL,
    [CEMPFAXNUM]       CHAR (9)   NOT NULL,
    [CEMPFAXRAM]       CHAR (5)   NOT NULL,
    [CEmpPISAli]       SMALLMONEY NULL,
    [CEmpCOFAli]       SMALLMONEY NULL,
    [CEMPDTAEXP]       DATETIME   NULL,
    [CEMPFLEXP]        CHAR (100) NULL,
    [CEmpNFeEml]       CHAR (100) NULL,
    [CEmpCodContmatic] CHAR (10)  NULL,
    PRIMARY KEY CLUSTERED ([CEMPCOD] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCAEMPA]
    ON [dbo].[CAEMP]([CEMPNOM] ASC);


GO
CREATE NONCLUSTERED INDEX [ICAEMPB]
    ON [dbo].[CAEMP]([CEMPCECOD] ASC);

