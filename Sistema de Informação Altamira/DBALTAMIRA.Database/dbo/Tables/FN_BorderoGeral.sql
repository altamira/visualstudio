CREATE TABLE [dbo].[FN_BorderoGeral] (
    [fnbg_Codigo]  CHAR (3)   NOT NULL,
    [fnbg_Banco]   CHAR (15)  NOT NULL,
    [fnbg_Taxa]    REAL       NOT NULL,
    [fnbg_Valor]   MONEY      NOT NULL,
    [fnbg_Juros]   MONEY      NOT NULL,
    [fnbg_IOF]     MONEY      NOT NULL,
    [fnbg_Custos]  MONEY      NOT NULL,
    [fnbg_Liquido] MONEY      NOT NULL,
    [fnbg_Lock]    BINARY (8) NULL
);

