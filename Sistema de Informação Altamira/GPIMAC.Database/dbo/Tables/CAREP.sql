﻿CREATE TABLE [dbo].[CAREP] (
    [CVCOD]    CHAR (3)   NOT NULL,
    [CVNOM]    CHAR (50)  NULL,
    [CVABR]    CHAR (30)  NULL,
    [CVCOM]    SMALLMONEY NULL,
    [CVEND]    CHAR (50)  NULL,
    [CVFON]    CHAR (15)  NULL,
    [CVBAI]    CHAR (30)  NULL,
    [CVMUN]    CHAR (15)  NULL,
    [CvFON1]   CHAR (15)  NULL,
    [CvFON2]   CHAR (15)  NULL,
    [CVEST]    CHAR (2)   NULL,
    [CVDDD]    CHAR (3)   NULL,
    [CVDD2]    CHAR (3)   NULL,
    [CVCNPJ]   CHAR (18)  NULL,
    [CVMAIL]   CHAR (100) NULL,
    [CVCEP]    CHAR (9)   NULL,
    [CVANI]    DATETIME   NULL,
    [CVCORE]   CHAR (20)  NULL,
    [CVDD3]    CHAR (3)   NULL,
    [CVABR1]   CHAR (30)  NULL,
    [CVANI1]   DATETIME   NULL,
    [CVREG]    CHAR (2)   NULL,
    [CVMET]    MONEY      NULL,
    [CVMET1]   SMALLMONEY NULL,
    [CVMET2]   SMALLMONEY NULL,
    [CVMET3]   SMALLMONEY NULL,
    [CVMET4]   SMALLMONEY NULL,
    [CVMET5]   SMALLMONEY NULL,
    [CVMET6]   SMALLMONEY NULL,
    [CVMVAL1]  SMALLMONEY NULL,
    [CVMVAL2]  SMALLMONEY NULL,
    [CVMVAL3]  SMALLMONEY NULL,
    [CVMVAL4]  SMALLMONEY NULL,
    [CVMVAL5]  SMALLMONEY NULL,
    [CVMVAL6]  SMALLMONEY NULL,
    [CVSE1]    CHAR (6)   NULL,
    [CVMGLB]   MONEY      NULL,
    [CVMGP]    SMALLMONEY NULL,
    [CVMAR]    CHAR (1)   NULL,
    [CVGERCOD] CHAR (3)   NULL,
    [CVADM]    CHAR (1)   NULL,
    [CVIMP]    CHAR (1)   NULL,
    [CVUSU]    CHAR (20)  NULL,
    [CVComPar] CHAR (1)   NULL,
    [CVTip]    CHAR (1)   NULL,
    PRIMARY KEY CLUSTERED ([CVCOD] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCAREPA]
    ON [dbo].[CAREP]([CVNOM] ASC);


GO
CREATE NONCLUSTERED INDEX [ICAREPB]
    ON [dbo].[CAREP]([CVGERCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ICAREPC]
    ON [dbo].[CAREP]([CVUSU] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[CAREP] TO [altanet]
    AS [dbo];

