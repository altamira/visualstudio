CREATE TABLE [dbo].[INCAT44] (
    [C44Emp]       CHAR (2)        NOT NULL,
    [C44Dat]       DATETIME        NOT NULL,
    [C44ProCod]    CHAR (60)       NOT NULL,
    [C44ProNom]    CHAR (60)       NULL,
    [C44ProUni]    CHAR (5)        NULL,
    [C44CusUni]    MONEY           NULL,
    [C44ProOri]    SMALLINT        NULL,
    [C44QtdEst]    DECIMAL (11, 4) NULL,
    [C44IcmAliInt] SMALLMONEY      NULL,
    [C44IcmAli]    SMALLMONEY      NULL,
    [C44IVA]       SMALLMONEY      NULL,
    [C44PreFin]    MONEY           NULL,
    [C44ProTip]    SMALLINT        NULL,
    [C44Mod]       CHAR (1)        NULL,
    PRIMARY KEY CLUSTERED ([C44Emp] ASC, [C44Dat] ASC, [C44ProCod] ASC)
);

