CREATE TABLE [dbo].[LPC2] (
    [Lpc0Emp]    CHAR (2)        NOT NULL,
    [Lpc0Ped]    INT             NOT NULL,
    [Lpc2Seq]    SMALLINT        NOT NULL,
    [Lpc2Cod]    CHAR (15)       NULL,
    [Lpc2Qua]    DECIMAL (11, 4) NULL,
    [Lpc2Pre]    DECIMAL (13, 4) NULL,
    [Lpc2DesDet] VARCHAR (2000)  NULL,
    [Lpc2Ent]    DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([Lpc0Emp] ASC, [Lpc0Ped] ASC, [Lpc2Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ULPC2A]
    ON [dbo].[LPC2]([Lpc0Emp] ASC, [Lpc0Ped] ASC, [Lpc2Seq] DESC);


GO
CREATE NONCLUSTERED INDEX [ILPC2C]
    ON [dbo].[LPC2]([Lpc2Cod] ASC);

