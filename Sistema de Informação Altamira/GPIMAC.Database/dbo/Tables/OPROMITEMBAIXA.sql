CREATE TABLE [dbo].[OPROMITEMBAIXA] (
    [OPR0Emp]           CHAR (2)     NOT NULL,
    [OPR0Cod]           INT          NOT NULL,
    [OPR1OPEmp]         CHAR (2)     NOT NULL,
    [OPR1OPCod]         INT          NOT NULL,
    [OPR1CPbCod]        CHAR (60)    NOT NULL,
    [OPr2BaiSeq]        SMALLINT     NOT NULL,
    [OPR2BaiDat]        DATETIME     NULL,
    [OPR2BaiDtH]        DATETIME     NULL,
    [OPR2BaiUsu]        CHAR (20)    NULL,
    [OPR2BaiQtd]        DECIMAL (10) NULL,
    [OPR2BaiCSerCodPrx] CHAR (8)     NULL,
    [OPR2OPR0EmpPrx]    CHAR (2)     NULL,
    [OPR2OPR0CodPrx]    INT          NULL,
    PRIMARY KEY CLUSTERED ([OPR0Emp] ASC, [OPR0Cod] ASC, [OPR1OPEmp] ASC, [OPR1OPCod] ASC, [OPR1CPbCod] ASC, [OPr2BaiSeq] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IOPROMITEMBAIXAC]
    ON [dbo].[OPROMITEMBAIXA]([OPR2BaiCSerCodPrx] ASC);


GO
CREATE NONCLUSTERED INDEX [IOPROMITEMBAIXAD]
    ON [dbo].[OPROMITEMBAIXA]([OPR2OPR0EmpPrx] ASC, [OPR2OPR0CodPrx] ASC, [OPR1OPEmp] ASC, [OPR1OPCod] ASC, [OPR1CPbCod] ASC);

