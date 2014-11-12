CREATE TABLE [dbo].[CACPG] (
    [CPCOD]       CHAR (3)       NOT NULL,
    [CPNOM]       CHAR (254)     NULL,
    [CPDI1]       SMALLINT       NULL,
    [CPDI2]       SMALLINT       NULL,
    [CPDI3]       SMALLINT       NULL,
    [CPDI4]       SMALLINT       NULL,
    [CPDI5]       SMALLINT       NULL,
    [CPDI6]       SMALLINT       NULL,
    [CPDI7]       SMALLINT       NULL,
    [CPDI8]       SMALLINT       NULL,
    [CPDI9]       SMALLINT       NULL,
    [CCPg0UltSeq] SMALLINT       NULL,
    [CPIMP]       SMALLINT       NULL,
    [CCPG0Si1Par] CHAR (1)       NULL,
    [CCPG0Vis]    CHAR (1)       NULL,
    [CpObs]       VARCHAR (1000) NULL,
    [CPNOMBusca]  CHAR (254)     NULL,
    PRIMARY KEY CLUSTERED ([CPCOD] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCACPGA]
    ON [dbo].[CACPG]([CPNOM] ASC);

