CREATE TABLE [dbo].[LAESPNF2RIR] (
    [NOTEMP]    CHAR (2)        NOT NULL,
    [NOTNUM]    INT             NOT NULL,
    [NOTTip]    CHAR (1)        NOT NULL,
    [NO1SEQ]    SMALLINT        NOT NULL,
    [No2RirCod] INT             NOT NULL,
    [No2Qtd]    DECIMAL (11, 4) NULL,
    PRIMARY KEY CLUSTERED ([NOTEMP] ASC, [NOTNUM] ASC, [NOTTip] ASC, [NO1SEQ] ASC, [No2RirCod] ASC)
);

