CREATE TABLE [dbo].[CCOEMPTABINS] (
    [CEMPCOD]       CHAR (2)   NOT NULL,
    [CBACOD]        CHAR (3)   NOT NULL,
    [CagCod]        SMALLINT   NOT NULL,
    [CcoCod]        CHAR (11)  NOT NULL,
    [EmpCobTip]     CHAR (1)   NOT NULL,
    [EmpCob1TabCod] CHAR (50)  NOT NULL,
    [EmpCob3Cod]    CHAR (50)  NOT NULL,
    [EmpCob3Nom]    CHAR (255) NOT NULL,
    [EmpCob3Sel]    SMALLINT   NOT NULL,
    PRIMARY KEY CLUSTERED ([CEMPCOD] ASC, [CBACOD] ASC, [CagCod] ASC, [CcoCod] ASC, [EmpCobTip] ASC, [EmpCob1TabCod] ASC, [EmpCob3Cod] ASC)
);

