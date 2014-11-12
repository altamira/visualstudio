CREATE TABLE [dbo].[LNFGRTCAB] (
    [LnfGrT0Emp]    CHAR (2)  NOT NULL,
    [LnfGrT0Usu]    CHAR (20) NOT NULL,
    [LnfGrT0Cnpj]   CHAR (18) NOT NULL,
    [LnfGrT0NFo]    INT       NULL,
    [LnfGrT0DatEmi] DATETIME  NULL,
    [LnfGrT0DatEnt] DATETIME  NULL,
    [LnfGrT0FreTot] MONEY     NULL,
    [LnfGrT0CpCod]  CHAR (3)  NULL,
    [LnfGrT0VctAut] CHAR (1)  NULL,
    PRIMARY KEY CLUSTERED ([LnfGrT0Emp] ASC, [LnfGrT0Usu] ASC, [LnfGrT0Cnpj] ASC)
);

