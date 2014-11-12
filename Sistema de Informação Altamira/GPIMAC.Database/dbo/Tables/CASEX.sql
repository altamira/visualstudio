CREATE TABLE [dbo].[CASEX] (
    [CTSERCO]   CHAR (7)        NOT NULL,
    [CTSERNO]   CHAR (30)       NULL,
    [CTSEREM]   CHAR (30)       NULL,
    [CTSERLI]   INT             NULL,
    [CTSERCU]   DECIMAL (13, 4) NULL,
    [CTSERUN]   CHAR (2)        NULL,
    [CTSERCUDT] DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([CTSERCO] ASC)
);

