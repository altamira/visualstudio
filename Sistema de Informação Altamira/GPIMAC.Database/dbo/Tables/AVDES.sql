CREATE TABLE [dbo].[AVDES] (
    [AvCod]  SMALLINT  NOT NULL,
    [AvDta]  DATETIME  NULL,
    [AvSet]  CHAR (20) NULL,
    [AvVal]  CHAR (60) NULL,
    [AvFun]  CHAR (60) NULL,
    [AvVali] CHAR (60) NULL,
    [AvFunc] CHAR (60) NULL,
    PRIMARY KEY CLUSTERED ([AvCod] ASC)
);

