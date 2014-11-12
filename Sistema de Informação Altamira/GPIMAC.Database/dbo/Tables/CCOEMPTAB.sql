CREATE TABLE [dbo].[CCOEMPTAB] (
    [CEMPCOD]       CHAR (2)   NOT NULL,
    [CBACOD]        CHAR (3)   NOT NULL,
    [CagCod]        SMALLINT   NOT NULL,
    [CcoCod]        CHAR (11)  NOT NULL,
    [EmpCobTip]     CHAR (1)   NOT NULL,
    [EmpCob1TabCod] CHAR (50)  NOT NULL,
    [EmpCob1TabNom] CHAR (100) NOT NULL,
    [EmpCob1TabMul] CHAR (1)   NOT NULL,
    PRIMARY KEY CLUSTERED ([CEMPCOD] ASC, [CBACOD] ASC, [CagCod] ASC, [CcoCod] ASC, [EmpCobTip] ASC, [EmpCob1TabCod] ASC)
);

