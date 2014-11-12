CREATE TABLE [dbo].[LAMOVESTRES] (
    [MovRes0Emp]    CHAR (2)        NOT NULL,
    [MovRes0ProTip] CHAR (2)        NOT NULL,
    [MovRes0ProCod] CHAR (60)       NOT NULL,
    [MovRes0RirCod] INT             NOT NULL,
    [MovRes0Ori]    CHAR (2)        NOT NULL,
    [MovRes0OriNum] INT             NOT NULL,
    [MovRes0OriIt]  SMALLINT        NOT NULL,
    [MovRes0Qtd]    DECIMAL (11, 4) NULL,
    [MovRes0Usu]    CHAR (20)       NULL,
    [MovRes0DtH]    DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([MovRes0Emp] ASC, [MovRes0ProTip] ASC, [MovRes0ProCod] ASC, [MovRes0RirCod] ASC, [MovRes0Ori] ASC, [MovRes0OriNum] ASC, [MovRes0OriIt] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ULAMOVESTRESA]
    ON [dbo].[LAMOVESTRES]([MovRes0Usu] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAMOVESTRESB]
    ON [dbo].[LAMOVESTRES]([MovRes0Emp] ASC, [MovRes0ProTip] ASC, [MovRes0ProCod] ASC, [MovRes0RirCod] ASC, [MovRes0OriNum] ASC, [MovRes0OriIt] ASC, [MovRes0Ori] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAMOVESTRESD]
    ON [dbo].[LAMOVESTRES]([MovRes0Emp] ASC, [MovRes0ProTip] ASC, [MovRes0ProCod] ASC, [MovRes0OriNum] ASC, [MovRes0OriIt] ASC, [MovRes0Ori] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAMOVESTRESE]
    ON [dbo].[LAMOVESTRES]([MovRes0Emp] ASC, [MovRes0ProTip] ASC, [MovRes0ProCod] ASC, [MovRes0Ori] ASC, [MovRes0OriNum] ASC, [MovRes0OriIt] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAMOVEMPF]
    ON [dbo].[LAMOVESTRES]([MovRes0Emp] ASC, [MovRes0ProCod] ASC, [MovRes0RirCod] ASC, [MovRes0OriNum] ASC, [MovRes0Ori] ASC, [MovRes0OriIt] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAMOVEMPG]
    ON [dbo].[LAMOVESTRES]([MovRes0ProCod] ASC, [MovRes0RirCod] ASC, [MovRes0OriNum] ASC, [MovRes0Ori] ASC, [MovRes0OriIt] ASC);

