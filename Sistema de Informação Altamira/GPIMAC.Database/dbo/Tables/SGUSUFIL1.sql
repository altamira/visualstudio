CREATE TABLE [dbo].[SGUSUFIL1] (
    [FilCod]   SMALLINT   NOT NULL,
    [Fil1Maq]  CHAR (255) NOT NULL,
    [Fil1Usu]  CHAR (255) NULL,
    [Fil1DtHr] DATETIME   NULL,
    PRIMARY KEY CLUSTERED ([FilCod] ASC, [Fil1Maq] ASC)
);

