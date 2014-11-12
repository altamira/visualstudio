CREATE TABLE [dbo].[LAORV1] (
    [Lo0Emp]     CHAR (2)        NOT NULL,
    [Lo0PED]     INT             NOT NULL,
    [Lo1Seq]     SMALLINT        NOT NULL,
    [Lo1CProCod] CHAR (60)       NULL,
    [Lo1CProCli] CHAR (20)       NULL,
    [Lo1CProNom] CHAR (120)      NULL,
    [Lo1CProUni] CHAR (2)        NULL,
    [Lo1CProPre] MONEY           NULL,
    [Lo1CfCod]   CHAR (5)        NULL,
    [Lo1Pre]     MONEY           NULL,
    [Lo1Qua]     DECIMAL (11, 4) NULL,
    [Lo1Ent]     DATETIME        NULL,
    [Lo1Dias]    SMALLINT        NULL,
    [Lo1DiasDes] CHAR (12)       NULL,
    [Lo1CProOut] SMALLINT        NULL,
    [Lo1Sta]     CHAR (1)        NULL,
    [Lo1LpEmp]   CHAR (2)        NULL,
    [Lo1LpPed]   INT             NULL,
    [Lo1LpIte]   SMALLINT        NULL,
    [Lo1Obs01]   CHAR (50)       NULL,
    [Lo1Obs02]   CHAR (50)       NULL,
    [Lo1Obs03]   CHAR (50)       NULL,
    [Lo1Obs04]   CHAR (50)       NULL,
    [Lo1Obs05]   CHAR (50)       NULL,
    [Lo1Fab]     CHAR (1)        NULL,
    [Lo1DesDet]  VARCHAR (2000)  NULL,
    CONSTRAINT [PK__LAORV1__7F3EC4977D8391DF] PRIMARY KEY CLUSTERED ([Lo0Emp] ASC, [Lo0PED] ASC, [Lo1Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILAORV1B]
    ON [dbo].[LAORV1]([Lo1CfCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAORV1A]
    ON [dbo].[LAORV1]([Lo0Emp] ASC, [Lo0PED] ASC, [Lo1Sta] ASC, [Lo1Seq] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAORV1B]
    ON [dbo].[LAORV1]([Lo1Sta] ASC, [Lo0PED] DESC);

