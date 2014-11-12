CREATE TABLE [dbo].[LACUST] (
    [LNCCOD]       CHAR (60)       NOT NULL,
    [LNCSeq]       CHAR (2)        NOT NULL,
    [LNCNOM]       CHAR (120)      NULL,
    [LNCUNI]       CHAR (2)        NULL,
    [LNCTIPO]      CHAR (4)        NULL,
    [LNCCLI]       CHAR (25)       NULL,
    [LNCPRE]       MONEY           NULL,
    [LNCAPR]       CHAR (1)        NULL,
    [LNCCON]       CHAR (30)       NULL,
    [LNCFON]       CHAR (12)       NULL,
    [LNCQUA]       DECIMAL (11, 4) NULL,
    [LNCDAT]       DATETIME        NULL,
    [LNCOBS]       CHAR (80)       NULL,
    [LNCSIM]       CHAR (11)       NULL,
    [LNCVAR]       SMALLINT        NULL,
    [LNCULTLCCSEQ] INT             NULL,
    [LNCULTLCISEQ] INT             NULL,
    [LNCEmp]       CHAR (2)        NULL,
    CONSTRAINT [PK__LACUST__0392284829CC2871] PRIMARY KEY CLUSTERED ([LNCCOD] ASC, [LNCSeq] ASC)
);

