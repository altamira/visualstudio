CREATE TABLE [dbo].[SGUSU] (
    [SgUsu0Cod]         CHAR (20)      NOT NULL,
    [SgUsu0Dat]         DATETIME       NULL,
    [SgUsu0Nom]         CHAR (50)      NULL,
    [SgUsu0Des]         VARCHAR (1000) NULL,
    [SgUsu0Atv]         CHAR (1)       NULL,
    [SgUsu0Sen]         CHAR (50)      NULL,
    [SgUsu0SenDica]     CHAR (50)      NULL,
    [SgUsu0Eml]         CHAR (70)      NULL,
    [SgUsu0PerCod]      CHAR (20)      NULL,
    [SgUsu0EmpSimult]   CHAR (1)       NULL,
    [SgUsu0EmlSmtp]     CHAR (70)      NULL,
    [SgUsu0EmlSmtpPort] SMALLINT       NULL,
    [SgUsu0EmlSmtpAut]  SMALLINT       NULL,
    [SgUsu0EmlSmtpUsr]  CHAR (70)      NULL,
    [SgUsu0EmlSmtpPwd]  CHAR (70)      NULL,
    PRIMARY KEY CLUSTERED ([SgUsu0Cod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [USGUSUA]
    ON [dbo].[SGUSU]([SgUsu0Dat] ASC, [SgUsu0Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [USGUSUB]
    ON [dbo].[SGUSU]([SgUsu0Atv] ASC, [SgUsu0Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [USGUSUC]
    ON [dbo].[SGUSU]([SgUsu0PerCod] ASC, [SgUsu0Cod] ASC);


GO
DENY ALTER
    ON OBJECT::[dbo].[SGUSU] TO [scada]
    AS [dbo];


GO
DENY CONTROL
    ON OBJECT::[dbo].[SGUSU] TO [scada]
    AS [dbo];


GO
DENY DELETE
    ON OBJECT::[dbo].[SGUSU] TO [scada]
    AS [dbo];


GO
DENY INSERT
    ON OBJECT::[dbo].[SGUSU] TO [scada]
    AS [dbo];


GO
DENY SELECT
    ON OBJECT::[dbo].[SGUSU] TO [scada]
    AS [dbo];


GO
DENY UPDATE
    ON OBJECT::[dbo].[SGUSU] TO [scada]
    AS [dbo];


GO
DENY ALTER
    ON OBJECT::[dbo].[SGUSU] TO [gestao]
    AS [dbo];


GO
DENY CONTROL
    ON OBJECT::[dbo].[SGUSU] TO [gestao]
    AS [dbo];


GO
DENY DELETE
    ON OBJECT::[dbo].[SGUSU] TO [gestao]
    AS [dbo];


GO
DENY INSERT
    ON OBJECT::[dbo].[SGUSU] TO [gestao]
    AS [dbo];


GO
DENY SELECT
    ON OBJECT::[dbo].[SGUSU] TO [gestao]
    AS [dbo];


GO
DENY UPDATE
    ON OBJECT::[dbo].[SGUSU] TO [gestao]
    AS [dbo];

