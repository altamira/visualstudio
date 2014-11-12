CREATE TABLE [dbo].[CCOEMP1] (
    [CEMPCOD]        CHAR (2)  NOT NULL,
    [CBACOD]         CHAR (3)  NOT NULL,
    [CagCod]         SMALLINT  NOT NULL,
    [CcoCod]         CHAR (11) NOT NULL,
    [EmpCobTip]      CHAR (1)  NOT NULL,
    [EmpCobCar]      CHAR (6)  NULL,
    [EmpCobCli]      CHAR (30) NULL,
    [EmpCobEsp]      CHAR (2)  NULL,
    [EmpCobEspDes]   CHAR (30) NULL,
    [EmpCobAc]       CHAR (1)  NULL,
    [EmpCobUsBco]    CHAR (15) NULL,
    [EmpCobInst1]    INT       NULL,
    [EmpCobInstDes]  CHAR (30) NULL,
    [EmpCobInst2]    INT       NULL,
    [EmpCobInstDesc] CHAR (30) NULL,
    [EmpCobfaxIni]   INT       NULL,
    [EmpCobFaxFin]   INT       NULL,
    [EmpCobFaxUlt]   INT       NULL,
    PRIMARY KEY CLUSTERED ([CEMPCOD] ASC, [CBACOD] ASC, [CagCod] ASC, [CcoCod] ASC, [EmpCobTip] ASC)
);

