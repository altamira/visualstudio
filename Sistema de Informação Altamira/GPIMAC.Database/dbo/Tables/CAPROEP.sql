CREATE TABLE [dbo].[CAPROEP] (
    [CPROCOD]    CHAR (60)      NOT NULL,
    [CPRO1EP]    CHAR (2)       NOT NULL,
    [CPRONOR]    CHAR (20)      NULL,
    [CPROREV]    CHAR (5)       NULL,
    [CPRODES]    CHAR (20)      NULL,
    [CProDesTec] VARCHAR (5000) NULL,
    [CPROMIN]    INT            NULL,
    [CPROREVDAT] DATETIME       NULL,
    [CPRO1EPPad] SMALLINT       NULL,
    PRIMARY KEY CLUSTERED ([CPROCOD] ASC, [CPRO1EP] ASC)
);

