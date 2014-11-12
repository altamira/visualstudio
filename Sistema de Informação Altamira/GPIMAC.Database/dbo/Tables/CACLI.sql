CREATE TABLE [dbo].[CACLI] (
    [CCCGC]         CHAR (18)  NOT NULL,
    [CCNOM]         CHAR (50)  NULL,
    [CCLIM]         MONEY      NULL,
    [CCINS]         CHAR (20)  NULL,
    [CCPAG]         CHAR (50)  NULL,
    [CCFAN]         CHAR (50)  NULL,
    [CCBAI]         CHAR (30)  NULL,
    [CCCID]         CHAR (30)  NULL,
    [CCEND]         CHAR (50)  NULL,
    [CCESO]         CHAR (90)  NULL,
    [CCCEP]         CHAR (9)   NULL,
    [CCSET]         CHAR (10)  NULL,
    [CCFAX]         CHAR (9)   NULL,
    [CCFDD]         CHAR (3)   NULL,
    [CCCON]         CHAR (100) NULL,
    [CCFON]         CHAR (9)   NULL,
    [CTCOD]         CHAR (5)   NULL,
    [CPCOD]         CHAR (3)   NULL,
    [CCENB]         CHAR (3)   NULL,
    [CCCLA]         CHAR (2)   NULL,
    [CCCEN]         CHAR (50)  NULL,
    [CCCBA]         CHAR (30)  NULL,
    [CCCCI]         CHAR (30)  NULL,
    [CCCcEP]        CHAR (9)   NULL,
    [CCCES]         CHAR (2)   NULL,
    [CCDES]         MONEY      NULL,
    [CVCOD]         CHAR (3)   NULL,
    [CCCOM]         SMALLMONEY NULL,
    [CEMPCOD]       CHAR (2)   NULL,
    [CCOBS]         CHAR (30)  NULL,
    [CCTOT]         MONEY      NULL,
    [CCVE1]         CHAR (2)   NULL,
    [CCVE2]         CHAR (2)   NULL,
    [CCVEN1]        CHAR (30)  NULL,
    [CCVEN2]        CHAR (30)  NULL,
    [CCFRE]         CHAR (1)   NULL,
    [CCLUG]         SMALLINT   NULL,
    [CCTKG]         SMALLMONEY NULL,
    [CCOBS1]        CHAR (80)  NULL,
    [CCtFO3]        CHAR (9)   NULL,
    [CCFA2]         CHAR (9)   NULL,
    [CCCO1]         CHAR (100) NULL,
    [CCDIV]         DATETIME   NULL,
    [CCDD5]         CHAR (3)   NULL,
    [CCDD6]         CHAR (3)   NULL,
    [CCMAIL]        CHAR (100) NULL,
    [CECOD]         CHAR (2)   NULL,
    [CCCRE]         CHAR (1)   NULL,
    [CCTOT1]        MONEY      NULL,
    [CCDTA]         DATETIME   NULL,
    [CCIQF]         SMALLINT   NULL,
    [CCPLACOD]      CHAR (3)   NULL,
    [CCSPLCOD]      CHAR (3)   NULL,
    [CCSIG]         CHAR (5)   NULL,
    [CatCod]        SMALLINT   NULL,
    [CCSUF]         CHAR (11)  NULL,
    [CCPACOM]       CHAR (1)   NULL,
    [CCFOP]         CHAR (6)   NULL,
    [CCDD1]         CHAR (3)   NULL,
    [CCATCO]        CHAR (3)   NULL,
    [CCATNO]        CHAR (50)  NULL,
    [CCFINA]        CHAR (1)   NULL,
    [CCBRES]        CHAR (1)   NULL,
    [CCMIC]         SMALLINT   NULL,
    [CCICMSP]       SMALLINT   NULL,
    [CCICMSPALI]    SMALLMONEY NULL,
    [CCICMSPCACODI] SMALLINT   NULL,
    [CCICMSPOBS]    CHAR (30)  NULL,
    [CCPc0Cod]      INT        NULL,
    [CCULTSEQ]      SMALLINT   NULL,
    [CCPES]         CHAR (1)   NULL,
    [CCMAR]         CHAR (1)   NULL,
    [CCDES1]        SMALLINT   NULL,
    [CCPRF]         CHAR (1)   NULL,
    [CCVIS]         SMALLINT   NULL,
    [CCLogTip0CodP] CHAR (3)   NULL,
    [CCEndNum]      CHAR (10)  NULL,
    [CCEndCpl]      CHAR (30)  NULL,
    [CCLogTip0CodC] CHAR (3)   NULL,
    [CCCENNum]      CHAR (10)  NULL,
    [CCCENCpl]      CHAR (30)  NULL,
    [CCInsMun]      INT        NULL,
    [CCCIDIBGECOD]  INT        NULL,
    [CCCCIIBGECOD]  INT        NULL,
    [CCTIPCLI]      SMALLINT   NULL,
    [CCIPIIse]      CHAR (1)   NULL,
    [CcCodAnt]      INT        NULL,
    [CCExpLocEmb]   CHAR (60)  NULL,
    [CCExpUFEmb]    CHAR (2)   NULL,
    [CCPai]         SMALLINT   NULL,
    [CCMon]         CHAR (1)   NULL,
    [CCCaPlC0Cod]   CHAR (11)  NULL,
    [CcCTCOD]       CHAR (5)   NULL,
    PRIMARY KEY CLUSTERED ([CCCGC] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ICACLIB]
    ON [dbo].[CACLI]([CVCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLIC]
    ON [dbo].[CACLI]([CTCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLID]
    ON [dbo].[CACLI]([CEMPCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLIE]
    ON [dbo].[CACLI]([CPCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [UCACLIB]
    ON [dbo].[CACLI]([CCTOT] DESC);


GO
CREATE NONCLUSTERED INDEX [UCACLIC]
    ON [dbo].[CACLI]([CCLUG] ASC);


GO
CREATE NONCLUSTERED INDEX [UCACLID]
    ON [dbo].[CACLI]([CCLUG] DESC);


GO
CREATE NONCLUSTERED INDEX [ICACLIF]
    ON [dbo].[CACLI]([CECOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLIG]
    ON [dbo].[CACLI]([CCSPLCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLIH]
    ON [dbo].[CACLI]([CCPLACOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLII]
    ON [dbo].[CACLI]([CatCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLIJ]
    ON [dbo].[CACLI]([CCICMSPCACODI] ASC);


GO
CREATE NONCLUSTERED INDEX [UCACLIF]
    ON [dbo].[CACLI]([CCPc0Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLIK]
    ON [dbo].[CACLI]([CCLogTip0CodP] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLIL]
    ON [dbo].[CACLI]([CCLogTip0CodC] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLIM]
    ON [dbo].[CACLI]([CCCIDIBGECOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLIN]
    ON [dbo].[CACLI]([CCCCIIBGECOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLIO]
    ON [dbo].[CACLI]([CCCaPlC0Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [UCACLIA]
    ON [dbo].[CACLI]([CCNOM] ASC);


GO
CREATE NONCLUSTERED INDEX [UCACLIE]
    ON [dbo].[CACLI]([CCFAN] ASC, [CCNOM] ASC, [CCCID] ASC, [CCCLA] ASC);


GO

CREATE TRIGGER UPDATE_DBALTAMIRA_VE_CLIENTESNOVO_TRIGGER ON CACLI
   AFTER INSERT, UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	DECLARE @CCCGC AS CHAR(18)
	DECLARE @VECL_CODIGO AS CHAR(14)
	
	SET @CCCGC = (SELECT CCCGC FROM INSERTED)
	SET @VECL_CODIGO = CAST(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(@CCCGC, '.', ''), '/', ''), '-', ''), ' ', ''))) AS CHAR(14))
	
	EXEC DBALTAMIRA.[dbo].[_GPIMAC_UPDATE_CLIENTESNOVO] @VECL_CODIGO


END

GO
DISABLE TRIGGER [dbo].[UPDATE_DBALTAMIRA_VE_CLIENTESNOVO_TRIGGER]
    ON [dbo].[CACLI];


GO
GRANT SELECT
    ON OBJECT::[dbo].[CACLI] TO [altanet]
    AS [dbo];

