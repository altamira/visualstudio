CREATE TABLE [dbo].[LRC] (
    [Lrc0Emp]    CHAR (2)  NOT NULL,
    [Lrc0Cod]    INT       NOT NULL,
    [Lrc0Dat]    DATETIME  NULL,
    [Lrc0SetCod] CHAR (3)  NULL,
    [Lrc0Sol]    CHAR (30) NULL,
    [Lrc0Seq]    SMALLINT  NULL,
    PRIMARY KEY CLUSTERED ([Lrc0Emp] ASC, [Lrc0Cod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILRCB]
    ON [dbo].[LRC]([Lrc0SetCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ULRCA]
    ON [dbo].[LRC]([Lrc0Cod] ASC, [Lrc0Dat] ASC, [Lrc0Sol] ASC);


GO
CREATE NONCLUSTERED INDEX [ULRCB]
    ON [dbo].[LRC]([Lrc0Cod] DESC);

