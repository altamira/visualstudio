CREATE TABLE [dbo].[GPEMP] (
    [GPEmpCod]     CHAR (2)  NOT NULL,
    [GPEmpNomRed]  CHAR (30) NOT NULL,
    [GPEmpRazSoc]  CHAR (70) NOT NULL,
    [GPEmpCnpjCpf] CHAR (14) NOT NULL,
    [GPEmpPes]     CHAR (1)  NOT NULL,
    [GPEmpIERG]    CHAR (14) NOT NULL,
    [GPEmpDatCad]  DATETIME  NOT NULL,
    [GPEmpUsuCri]  CHAR (20) NOT NULL,
    [GPEmpDtHCri]  DATETIME  NOT NULL,
    [GpEmpUsuAlt]  CHAR (20) NOT NULL,
    [GpEmpDtHAlt]  DATETIME  NOT NULL,
    [GpEmpUf]      SMALLINT  NOT NULL,
    [GpEmpLoga]    CHAR (60) NOT NULL,
    [GpEmpLogNum]  CHAR (10) NOT NULL,
    [GpempLogCom]  CHAR (60) NOT NULL,
    [GpEmpLogBai]  CHAR (50) NOT NULL,
    [GpEmpCodMun]  INT       NOT NULL,
    [GpEmpCep]     CHAR (9)  NOT NULL,
    [GpEmpPai]     CHAR (10) NOT NULL,
    [GPEmpTelDDD]  CHAR (3)  NOT NULL,
    [GpEmpTel]     CHAR (9)  NOT NULL,
    [GpEmpCCM]     CHAR (14) NOT NULL,
    [GpEmpCnae]    CHAR (7)  NOT NULL,
    [GpEmpCrt]     SMALLINT  NULL,
    PRIMARY KEY CLUSTERED ([GPEmpCod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IGPEMP]
    ON [dbo].[GPEMP]([GpEmpCodMun] ASC);


GO
CREATE NONCLUSTERED INDEX [UGPEMPA]
    ON [dbo].[GPEMP]([GPEmpCod] DESC);

