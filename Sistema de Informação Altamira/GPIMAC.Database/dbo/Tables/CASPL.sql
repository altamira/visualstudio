﻿CREATE TABLE [dbo].[CASPL] (
    [C2PLA]    CHAR (3)  NOT NULL,
    [C2NOM]    CHAR (30) NULL,
    [C2VAL]    MONEY     NULL,
    [C2C1Pla]  CHAR (3)  NULL,
    [C2Rel]    CHAR (1)  NULL,
    [C2CodCnt] CHAR (11) NULL,
    PRIMARY KEY CLUSTERED ([C2PLA] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCASPLA]
    ON [dbo].[CASPL]([C2NOM] ASC);


GO
CREATE NONCLUSTERED INDEX [UCASPLB]
    ON [dbo].[CASPL]([C2C1Pla] ASC, [C2PLA] ASC);


GO
CREATE NONCLUSTERED INDEX [UCASPLC]
    ON [dbo].[CASPL]([C2C1Pla] ASC, [C2NOM] ASC);


GO
CREATE NONCLUSTERED INDEX [ICASPLC]
    ON [dbo].[CASPL]([C2CodCnt] ASC);

