CREATE TABLE [dbo].[LAESPPED1] (
    [Ped0EMP]    CHAR (2)        NOT NULL,
    [Ped0NUM]    INT             NOT NULL,
    [Ped0Tip]    CHAR (1)        NOT NULL,
    [Ped1SEQ]    SMALLINT        NOT NULL,
    [Ped1COD]    CHAR (60)       NULL,
    [Ped1NOM]    CHAR (120)      NULL,
    [Ped1CLA]    CHAR (5)        NULL,
    [Ped1UNI]    CHAR (2)        NULL,
    [Ped1QUA]    DECIMAL (11, 4) NULL,
    [Ped1PUN]    MONEY           NULL,
    [Ped1PLQ]    MONEY           NULL,
    [Ped1PBR]    MONEY           NULL,
    [Ped1MER]    MONEY           NULL,
    [Ped1BASCAL] MONEY           NULL,
    [Ped1PEICM]  SMALLMONEY      NULL,
    [Ped1PEIPI]  SMALLMONEY      NULL,
    [Ped1ICM]    MONEY           NULL,
    [Ped1IPI]    MONEY           NULL,
    [Ped1TOT]    MONEY           NULL,
    [Ped1OBS]    CHAR (80)       NULL,
    [Ped1OB1]    CHAR (80)       NULL,
    [Ped1OB2]    CHAR (80)       NULL,
    [Ped1OB3]    CHAR (80)       NULL,
    [Ped1OB4]    CHAR (80)       NULL,
    [Ped1CLI]    CHAR (15)       NULL,
    [Ped1PPE]    CHAR (20)       NULL,
    [Ped1SITTRB] CHAR (3)        NULL,
    [Ped1MovEst] INT             NULL,
    [Ped1Tip]    CHAR (2)        NULL,
    CONSTRAINT [PK__LAESPPED__C73E66DC6CF8245B] PRIMARY KEY CLUSTERED ([Ped0EMP] ASC, [Ped0NUM] ASC, [Ped0Tip] ASC, [Ped1SEQ] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ULAESPPED1A]
    ON [dbo].[LAESPPED1]([Ped1COD] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAESPPED1B]
    ON [dbo].[LAESPPED1]([Ped1CLA] ASC);

