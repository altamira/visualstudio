CREATE TABLE [dbo].[LAFAT1] (
    [PV0EMP]       CHAR (2)        NOT NULL,
    [PV0NUM]       INT             NOT NULL,
    [PV0Tip]       CHAR (1)        NOT NULL,
    [PV1SEQ]       SMALLINT        NOT NULL,
    [PV1COD]       CHAR (60)       NULL,
    [PV1NOM]       CHAR (120)      NULL,
    [PV1UNI]       CHAR (2)        NULL,
    [PV1SAL]       DECIMAL (11, 4) NULL,
    [PV1CUS]       MONEY           NULL,
    [PV1QUA]       DECIMAL (11, 4) NULL,
    [PV1VAL]       DECIMAL (13, 4) NULL,
    [PV1DES]       SMALLMONEY      NULL,
    [PV1CCFCOD]    CHAR (5)        NULL,
    [PV1IPI]       SMALLMONEY      NULL,
    [PV1ICM]       SMALLMONEY      NULL,
    [PV1PED]       INT             NULL,
    [PV0CLI]       CHAR (15)       NULL,
    [PV0PPE]       CHAR (20)       NULL,
    [PV1LUC]       SMALLMONEY      NULL,
    [PV1OBS]       CHAR (80)       NULL,
    [PV1OB1]       CHAR (80)       NULL,
    [PV1OB2]       CHAR (80)       NULL,
    [PV1OB3]       CHAR (80)       NULL,
    [PV1OB4]       CHAR (80)       NULL,
    [PV1ValCom]    MONEY           NULL,
    [PV1ORI]       CHAR (2)        NULL,
    [PV1ORIEMP]    CHAR (2)        NULL,
    [PV1ORINUM]    INT             NULL,
    [PV1ORISEQ]    SMALLINT        NULL,
    [PV1ELI]       CHAR (1)        NULL,
    [PV1TIP]       CHAR (2)        NULL,
    [PV1CFOP]      CHAR (6)        NULL,
    [Pv1DesDet]    VARCHAR (2000)  NULL,
    [Pv1CorCod]    CHAR (10)       NULL,
    [PV1SEGVAL]    MONEY           NULL,
    [PV1OUTDESACE] MONEY           NULL,
    CONSTRAINT [PK__LAFAT1__C97855B172B0FDB1] PRIMARY KEY CLUSTERED ([PV0EMP] ASC, [PV0NUM] ASC, [PV0Tip] ASC, [PV1SEQ] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ULAFAT1A]
    ON [dbo].[LAFAT1]([PV1COD] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFAT1B]
    ON [dbo].[LAFAT1]([PV1CCFCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFAT1C]
    ON [dbo].[LAFAT1]([PV0Tip] ASC, [PV1SEQ] ASC, [PV0EMP] ASC, [PV0NUM] ASC, [PV1COD] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFAT1D]
    ON [dbo].[LAFAT1]([PV1ORI] ASC, [PV1ORIEMP] ASC, [PV1ORINUM] ASC, [PV1ORISEQ] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFAT1]
    ON [dbo].[LAFAT1]([PV1CFOP] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFAT11]
    ON [dbo].[LAFAT1]([Pv1CorCod] ASC);

