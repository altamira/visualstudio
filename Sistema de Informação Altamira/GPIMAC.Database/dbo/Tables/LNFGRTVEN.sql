CREATE TABLE [dbo].[LNFGRTVEN] (
    [LnfGrT0Emp]  CHAR (2)  NOT NULL,
    [LnfGrT0Usu]  CHAR (20) NOT NULL,
    [LnfGrT0Cnpj] CHAR (18) NOT NULL,
    [LnfGrT1Seq]  SMALLINT  NOT NULL,
    [LnfGrT1Dup]  CHAR (30) NULL,
    [LnfGrT1Ven]  DATETIME  NULL,
    [LnfGrT1Val]  MONEY     NULL,
    PRIMARY KEY CLUSTERED ([LnfGrT0Emp] ASC, [LnfGrT0Usu] ASC, [LnfGrT0Cnpj] ASC, [LnfGrT1Seq] ASC)
);

