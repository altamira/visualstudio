CREATE TABLE [dbo].[LAESPNF3RBN] (
    [NOTEMP]       CHAR (2)        NOT NULL,
    [NOTNUM]       INT             NOT NULL,
    [NOTTip]       CHAR (1)        NOT NULL,
    [NO1SEQ]       SMALLINT        NOT NULL,
    [No3RBnOri]    CHAR (2)        NOT NULL,
    [No3RBnOriEmp] CHAR (2)        NOT NULL,
    [No3RBnOriNum] INT             NOT NULL,
    [No3RBnOriTip] CHAR (1)        NOT NULL,
    [No3RBnOriSeq] SMALLINT        NOT NULL,
    [No3RBnDtR]    DATETIME        NULL,
    [No3RBnQtd]    DECIMAL (11, 4) NULL,
    PRIMARY KEY CLUSTERED ([NOTEMP] ASC, [NOTNUM] ASC, [NOTTip] ASC, [NO1SEQ] ASC, [No3RBnOri] ASC, [No3RBnOriEmp] ASC, [No3RBnOriNum] ASC, [No3RBnOriTip] ASC, [No3RBnOriSeq] ASC)
);

