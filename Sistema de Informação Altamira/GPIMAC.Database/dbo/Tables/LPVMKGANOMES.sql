CREATE TABLE [dbo].[LPVMKGANOMES] (
    [Lp0KgEmp]    CHAR (2) NOT NULL,
    [Lp0KgAno]    SMALLINT NOT NULL,
    [Lp0KgMes]    SMALLINT NOT NULL,
    [Lp0KgMed]    MONEY    NULL,
    [Lp0KgAnoMes] INT      NULL,
    PRIMARY KEY CLUSTERED ([Lp0KgEmp] ASC, [Lp0KgAno] ASC, [Lp0KgMes] ASC)
);

