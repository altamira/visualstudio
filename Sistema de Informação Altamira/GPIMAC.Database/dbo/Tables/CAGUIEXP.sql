CREATE TABLE [dbo].[CAGUIEXP] (
    [Gui0Emp]     CHAR (2)        NOT NULL,
    [Gui0Cod]     INT             NOT NULL,
    [Gui0CnpjCpf] CHAR (18)       NULL,
    [Gui0PLi]     DECIMAL (11, 4) NULL,
    [Gui0PBr]     MONEY           NULL,
    [Gui0Esp]     CHAR (20)       NULL,
    [Gui0Vol]     MONEY           NULL,
    [Gui0CtCod]   CHAR (5)        NULL,
    [Gui0Dat]     DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([Gui0Emp] ASC, [Gui0Cod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ICAGUIEXP1]
    ON [dbo].[CAGUIEXP]([Gui0CtCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ICAGUIEXP2]
    ON [dbo].[CAGUIEXP]([Gui0CnpjCpf] ASC);


GO
CREATE NONCLUSTERED INDEX [UCAGUIEXPA]
    ON [dbo].[CAGUIEXP]([Gui0Emp] ASC, [Gui0Cod] DESC);

