CREATE TABLE [dbo].[LNF2] (
    [Lnf0Emp]     CHAR (2)  NOT NULL,
    [Lnf0Nfo]     INT       NOT NULL,
    [Lnf0Seq]     SMALLINT  NOT NULL,
    [Lnf0CliCnpj] CHAR (18) NOT NULL,
    [Lnf2Seq]     SMALLINT  NOT NULL,
    [Lnf2Dup]     SMALLINT  NOT NULL,
    [Lnf2Vct]     DATETIME  NOT NULL,
    [Lnf2Val]     MONEY     NOT NULL,
    PRIMARY KEY CLUSTERED ([Lnf0Emp] ASC, [Lnf0Nfo] ASC, [Lnf0Seq] ASC, [Lnf0CliCnpj] ASC, [Lnf2Seq] ASC)
);

