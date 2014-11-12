CREATE TABLE [dbo].[LRC1] (
    [Lrc0Emp]       CHAR (2)        NOT NULL,
    [Lrc0Cod]       INT             NOT NULL,
    [Lrc1Seq]       SMALLINT        NOT NULL,
    [Lrc1Cod]       CHAR (60)       NULL,
    [Lrc1Tip]       CHAR (2)        NULL,
    [Lrc1Qua]       DECIMAL (11, 4) NULL,
    [Lrc1Lpc0Emp]   CHAR (2)        NULL,
    [Lrc1Lpc0Ped]   INT             NULL,
    [Lrc1Pre]       DECIMAL (13, 4) NULL,
    [Lrc1LpcOrc]    INT             NULL,
    [Lrc1LpIOrc]    SMALLINT        NULL,
    [Lrc1Lpc1Seq]   SMALLINT        NULL,
    [Lrc1Ori]       CHAR (2)        NULL,
    [Lrc1OriNum]    INT             NULL,
    [Lrc1OriIt]     SMALLINT        NULL,
    [Lrc1OriDtE]    DATETIME        NULL,
    [Lrc1OriProCod] CHAR (60)       NULL,
    PRIMARY KEY CLUSTERED ([Lrc0Emp] ASC, [Lrc0Cod] ASC, [Lrc1Seq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ULRC1A]
    ON [dbo].[LRC1]([Lrc1Lpc0Ped] ASC, [Lrc0Emp] ASC, [Lrc0Cod] ASC, [Lrc1Seq] ASC);


GO
CREATE NONCLUSTERED INDEX [ILRC1C]
    ON [dbo].[LRC1]([Lrc1OriProCod] ASC);

