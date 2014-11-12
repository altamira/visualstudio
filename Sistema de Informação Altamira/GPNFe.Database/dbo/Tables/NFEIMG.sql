CREATE TABLE [dbo].[NFEIMG] (
    [NFeImg0Emp]           CHAR (2)        NOT NULL,
    [NFeImg0FatNum]        INT             NOT NULL,
    [NFeImg0FatTip]        CHAR (1)        NOT NULL,
    [NFeImg0FatCnpjCpfEmi] CHAR (14)       NOT NULL,
    [NfeImg0Img]           VARBINARY (MAX) NOT NULL,
    [NfeImg0Ext]           CHAR (5)        NOT NULL,
    CONSTRAINT [PK_NFEIMG] PRIMARY KEY CLUSTERED ([NFeImg0Emp] ASC, [NFeImg0FatNum] ASC, [NFeImg0FatTip] ASC, [NFeImg0FatCnpjCpfEmi] ASC)
);

