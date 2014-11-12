CREATE TABLE [dbo].[NFEENV] (
    [NFe0Emp]           CHAR (2)       NOT NULL,
    [NFe0FatNum]        INT            NOT NULL,
    [NFe0FatTip]        CHAR (1)       NOT NULL,
    [NFe0FatCnpjCpfEmi] CHAR (14)      NOT NULL,
    [NFeEnv0FatNumLot]  INT            NOT NULL,
    [NfeEnv0FatNumRec]  DECIMAL (15)   NOT NULL,
    [NFeEnv0TipEnv]     CHAR (1)       NOT NULL,
    [NfeEnv0UsuRes]     CHAR (20)      NOT NULL,
    [NfeEnv0DtHEnv]     DATETIME       NOT NULL,
    [NfeEnv0DtHRec]     DATETIME       NOT NULL,
    [NfeEnv0CodSta]     INT            NOT NULL,
    [NfeEnv0MsgRec]     VARCHAR (1000) NOT NULL,
    [NfeEnv0TpoRes]     INT            NOT NULL,
    CONSTRAINT [PK_NFEENV] PRIMARY KEY CLUSTERED ([NFe0Emp] ASC, [NFe0FatNum] ASC, [NFe0FatTip] ASC, [NFe0FatCnpjCpfEmi] ASC, [NFeEnv0FatNumLot] ASC)
);

