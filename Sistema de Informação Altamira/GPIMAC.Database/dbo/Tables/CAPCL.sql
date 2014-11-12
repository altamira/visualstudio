CREATE TABLE [dbo].[CAPCL] (
    [Pc0Cod]       INT            NOT NULL,
    [Pc0Cnpj]      CHAR (18)      NULL,
    [Pc0IE]        CHAR (20)      NULL,
    [Pc0Fan]       CHAR (50)      NULL,
    [Pc0Nom]       CHAR (50)      NULL,
    [Pc0End]       CHAR (50)      NULL,
    [Pc0Bai]       CHAR (30)      NULL,
    [Pc0Cep]       CHAR (9)       NULL,
    [Pc0Cid]       CHAR (30)      NULL,
    [Pc0TelDdd]    CHAR (3)       NULL,
    [Pc0TelNum]    CHAR (9)       NULL,
    [Pc0TelRam]    CHAR (5)       NULL,
    [Pc0FaxDdd]    CHAR (3)       NULL,
    [Pc0FaxNum]    CHAR (9)       NULL,
    [Pc0FaxRam]    CHAR (5)       NULL,
    [Pc0CvCod]     CHAR (3)       NULL,
    [Pc0Url]       CHAR (50)      NULL,
    [Pc0Eml]       CHAR (100)     NULL,
    [Pc0Ind]       CHAR (50)      NULL,
    [Pc0Obs]       VARCHAR (1000) NULL,
    [Pc0Pc1]       SMALLINT       NULL,
    [Pc0CodOld]    INT            NULL,
    [Pc0UfCod]     CHAR (2)       NULL,
    [Pc0Prf]       CHAR (1)       NULL,
    [Pc0VisPer]    SMALLINT       NULL,
    [Pc0LogTipCod] CHAR (3)       NULL,
    [Pc0EndNum]    CHAR (10)      NULL,
    [Pc0EndCpl]    CHAR (30)      NULL,
    [PC0Cla]       CHAR (2)       NULL,
    [Pc0Tip]       CHAR (1)       NOT NULL,
    PRIMARY KEY CLUSTERED ([Pc0Cod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ICAPCLB]
    ON [dbo].[CAPCL]([Pc0CvCod] ASC);


GO
CREATE NONCLUSTERED INDEX [UCAPCLA]
    ON [dbo].[CAPCL]([Pc0Cnpj] ASC);


GO
CREATE NONCLUSTERED INDEX [ICAPCLC]
    ON [dbo].[CAPCL]([Pc0UfCod] ASC);


GO
CREATE NONCLUSTERED INDEX [UCAPCLB]
    ON [dbo].[CAPCL]([Pc0Fan] ASC);


GO
CREATE NONCLUSTERED INDEX [ICAPCL]
    ON [dbo].[CAPCL]([Pc0LogTipCod] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[CAPCL] TO [altanet]
    AS [dbo];

