CREATE TABLE [dbo].[CAGUIEXP1] (
    [Gui0Emp]    CHAR (2)        NOT NULL,
    [Gui0Cod]    INT             NOT NULL,
    [Gui1Seq]    SMALLINT        NOT NULL,
    [Gui1ProCod] CHAR (60)       NULL,
    [Gui1Qtd]    DECIMAL (11, 4) NULL,
    [Gui1Ori]    CHAR (2)        NULL,
    [Gui1Ped]    INT             NULL,
    [Gui1ItPed]  SMALLINT        NULL,
    [Gui1EmpPed] CHAR (2)        NULL,
    [Gui1Bai]    DECIMAL (11, 4) NULL,
    PRIMARY KEY CLUSTERED ([Gui0Emp] ASC, [Gui0Cod] ASC, [Gui1Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ICAGUIEXPLEVEL12]
    ON [dbo].[CAGUIEXP1]([Gui1ProCod] ASC);

