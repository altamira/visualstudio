CREATE TABLE [dbo].[NfeChaAce] (
    [NFe0Emp]           CHAR (2)   NOT NULL,
    [NFe0FatNum]        INT        NOT NULL,
    [NFe0FatTip]        CHAR (1)   NOT NULL,
    [NFe0FatCnpjCpfEmi] CHAR (14)  NOT NULL,
    [NFe0FatSeq]        SMALLINT   NOT NULL,
    [NFe0_infNFe_Chave] CHAR (100) NULL,
    CONSTRAINT [PK_NfeChaAce] PRIMARY KEY CLUSTERED ([NFe0Emp] ASC, [NFe0FatNum] ASC, [NFe0FatTip] ASC, [NFe0FatCnpjCpfEmi] ASC, [NFe0FatSeq] ASC)
);

