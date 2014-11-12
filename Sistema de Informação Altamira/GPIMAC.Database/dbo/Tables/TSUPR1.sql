CREATE TABLE [dbo].[TSUPR1] (
    [TCpbID]  DECIMAL (14)    NOT NULL,
    [TCpbCod] CHAR (12)       NOT NULL,
    [TCpbDes] CHAR (40)       NULL,
    [TCpbUni] CHAR (2)        NULL,
    [TCpbQtd] DECIMAL (11, 4) NULL,
    PRIMARY KEY CLUSTERED ([TCpbID] ASC, [TCpbCod] ASC)
);

