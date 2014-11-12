CREATE TABLE [dbo].[ORDFABLANBAIXA] (
    [OrdEmp]        CHAR (2)        NOT NULL,
    [OrdCod]        INT             NOT NULL,
    [OrdBai1Seq]    SMALLINT        NOT NULL,
    [OrdBai1Dat]    DATETIME        NULL,
    [OrdBai1Qtd]    DECIMAL (11, 4) NULL,
    [OrdBai1RirCod] INT             NULL,
    [OrdBai1Obs]    VARCHAR (1000)  NULL,
    [OrdBai1MovLan] INT             NULL,
    [OrdBai1Tip]    CHAR (1)        NULL,
    [OrdBai1DtH]    DATETIME        NULL,
    [OrdBai1Usu]    CHAR (20)       NULL,
    [OrdBai1Bai]    CHAR (1)        NULL,
    [OrdBai1BaiDes] CHAR (3)        NULL,
    PRIMARY KEY CLUSTERED ([OrdEmp] ASC, [OrdCod] ASC, [OrdBai1Seq] ASC)
);

