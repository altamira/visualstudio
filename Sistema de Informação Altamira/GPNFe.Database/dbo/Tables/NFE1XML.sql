CREATE TABLE [dbo].[NFE1XML] (
    [NFe0Emp]           CHAR (2)   NOT NULL,
    [NFe0FatNum]        INT        NOT NULL,
    [NFe0FatTip]        CHAR (1)   NOT NULL,
    [NFe0FatCnpjCpfEmi] CHAR (14)  NOT NULL,
    [Nfe1XmlSeq]        SMALLINT   NOT NULL,
    [Nfe1FatXml]        CHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([NFe0Emp] ASC, [NFe0FatNum] ASC, [NFe0FatTip] ASC, [NFe0FatCnpjCpfEmi] ASC, [Nfe1XmlSeq] ASC)
);

