CREATE TABLE [dbo].[SGUSU] (
    [SgUsu0Cod]         CHAR (20)      NOT NULL,
    [SgUsu0Nom]         CHAR (30)      NOT NULL,
    [SgUsu0Sen]         CHAR (10)      NOT NULL,
    [SgUsu0Dat]         DATETIME       NOT NULL,
    [SgUsu0Des]         VARCHAR (1000) NOT NULL,
    [SgUsu0Atv]         CHAR (1)       NOT NULL,
    [SgUsu0SenDica]     CHAR (50)      NOT NULL,
    [SgUsu0Eml]         CHAR (70)      NOT NULL,
    [SgUsu0EmlSmtp]     CHAR (70)      NOT NULL,
    [SgUsu0EmlSmtpPort] SMALLINT       NOT NULL,
    [SgUsu0EmlSmtpAut]  SMALLINT       NOT NULL,
    [SgUsu0EmlSmtpUsr]  CHAR (70)      NOT NULL,
    [SgUsu0EmlSmtpPwd]  CHAR (70)      NOT NULL,
    [SgUsu0PerCod]      CHAR (20)      NOT NULL,
    [SgUsu0EmpSimult]   CHAR (1)       NOT NULL,
    CONSTRAINT [PK__SGUSU__7C8480AE] PRIMARY KEY CLUSTERED ([SgUsu0Cod] ASC)
);

