CREATE TABLE [dbo].[CACLIENDENT] (
    [CCCGC]            CHAR (18)  NOT NULL,
    [CCEnd1Seq]        SMALLINT   NOT NULL,
    [CCEnd1Des]        CHAR (30)  NULL,
    [CcEnd1LogTip0Cod] CHAR (3)   NULL,
    [CcEnd1End]        CHAR (50)  NULL,
    [CcEnd1EndNum]     CHAR (10)  NULL,
    [CcEnd1EndCpl]     CHAR (30)  NULL,
    [CcEnd1Bai]        CHAR (30)  NULL,
    [CcEnd1Cep]        CHAR (9)   NULL,
    [CcEnd1UFCod]      CHAR (2)   NULL,
    [CCEnd1CidIBGECod] INT        NULL,
    [CCEnd1Cid]        CHAR (50)  NULL,
    [CCEnd1TelDDD]     CHAR (5)   NULL,
    [CCEnd1TelNum]     CHAR (9)   NULL,
    [CcEnd1TelRam]     CHAR (5)   NULL,
    [CcEnd1FaxDDD]     CHAR (5)   NULL,
    [CcEnd1FaxNum]     CHAR (9)   NULL,
    [CcEnd1FaxRam]     CHAR (5)   NULL,
    [CcEnd1Eml]        CHAR (100) NULL,
    [CcEnd1Obs]        CHAR (100) NULL,
    [CcEnd1Cnpj]       CHAR (18)  NULL,
    [CcEnd1Pes]        CHAR (1)   NULL,
    [CcEnd1IE]         CHAR (20)  NULL,
    PRIMARY KEY CLUSTERED ([CCCGC] ASC, [CCEnd1Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ICACLIENDENTC]
    ON [dbo].[CACLIENDENT]([CcEnd1UFCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLIENDENTD]
    ON [dbo].[CACLIENDENT]([CcEnd1LogTip0Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [ICACLIENDENTE]
    ON [dbo].[CACLIENDENT]([CCEnd1CidIBGECod] ASC);


GO
CREATE NONCLUSTERED INDEX [UCACLIENDENTA]
    ON [dbo].[CACLIENDENT]([CCCGC] ASC, [CCEnd1Seq] DESC);

