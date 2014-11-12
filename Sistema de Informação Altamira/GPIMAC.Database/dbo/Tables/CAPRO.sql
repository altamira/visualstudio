CREATE TABLE [dbo].[CAPRO] (
    [CPROCOD]       CHAR (60)       NOT NULL,
    [CPRONOM]       CHAR (120)      NULL,
    [CPROUNI]       CHAR (2)        NULL,
    [CPROQUA]       DECIMAL (11, 4) NULL,
    [CPROCLI]       CHAR (20)       NULL,
    [CPRODAT]       DATETIME        NULL,
    [CPro0CTrf0Cod] CHAR (1)        NULL,
    [CPro0CClf0Cod] CHAR (5)        NULL,
    [CPro0CPrP0Cod] CHAR (1)        NULL,
    [CPROPRE]       DECIMAL (13, 4) NULL,
    [CPROPES]       MONEY           NULL,
    [CPROI01]       SMALLMONEY      NULL,
    [CPROI02]       DECIMAL (11, 4) NULL,
    [CPROI03]       DECIMAL (11, 4) NULL,
    [CPROI04]       DECIMAL (11, 4) NULL,
    [CPROI05]       DECIMAL (11, 4) NULL,
    [CPROI06]       DECIMAL (11, 4) NULL,
    [CPROI07]       DECIMAL (11, 4) NULL,
    [CPROI08]       DECIMAL (11, 4) NULL,
    [CPROI09]       DECIMAL (11, 4) NULL,
    [CPROI10]       DECIMAL (11, 4) NULL,
    [CPROI11]       DECIMAL (11, 4) NULL,
    [CPROI12]       DECIMAL (11, 4) NULL,
    [CPROCUS]       MONEY           NULL,
    [CPROCA1]       CHAR (4)        NULL,
    [CPROCA2]       CHAR (4)        NULL,
    [CPROCA3]       CHAR (4)        NULL,
    [CPROCA4]       CHAR (4)        NULL,
    [CPROCA5]       CHAR (4)        NULL,
    [CPRONOF]       CHAR (50)       NULL,
    [CProPriCom]    DATETIME        NULL,
    [CPROCAT]       CHAR (15)       NULL,
    [CPROTOT]       DECIMAL (11, 4) NULL,
    [CPROTO1]       MONEY           NULL,
    [CPRONCLI]      CHAR (20)       NULL,
    [CPRONDAT]      DATETIME        NULL,
    [CPRONREA]      SMALLMONEY      NULL,
    [CPRONPRE]      MONEY           NULL,
    [CGrco1]        CHAR (5)        NULL,
    [CPROPESEMB]    MONEY           NULL,
    [CPRODIASENT]   SMALLINT        NULL,
    [Cprocal]       CHAR (1)        NULL,
    [CPROBAR]       CHAR (15)       NULL,
    [CProSim]       CHAR (60)       NULL,
    [CaProUltImg]   SMALLINT        NULL,
    [CaProPro]      CHAR (20)       NULL,
    [CProAtv]       CHAR (1)        NULL,
    [CProEstIntFra] CHAR (1)        NULL,
    CONSTRAINT [PK__CAPRO__8DF6961D54B68676] PRIMARY KEY CLUSTERED ([CPROCOD] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCAPROA]
    ON [dbo].[CAPRO]([CPRONOM] ASC, [CPROCOD] ASC, [CPROCLI] ASC, [CPRONCLI] ASC);


GO
CREATE NONCLUSTERED INDEX [UCAPROB]
    ON [dbo].[CAPRO]([CProSim] ASC);


GO
CREATE NONCLUSTERED INDEX [UCAPROC]
    ON [dbo].[CAPRO]([CPROTO1] DESC);


GO
CREATE NONCLUSTERED INDEX [UCAPROD]
    ON [dbo].[CAPRO]([CPROTOT] DESC);


GO
CREATE NONCLUSTERED INDEX [ICAPROE]
    ON [dbo].[CAPRO]([CGrco1] ASC);


GO
CREATE NONCLUSTERED INDEX [ICAPRO]
    ON [dbo].[CAPRO]([CPro0CTrf0Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [ICAPRO1]
    ON [dbo].[CAPRO]([CPro0CPrP0Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [ICAPRO2]
    ON [dbo].[CAPRO]([CPro0CClf0Cod] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[CAPRO] TO [altanet]
    AS [dbo];

