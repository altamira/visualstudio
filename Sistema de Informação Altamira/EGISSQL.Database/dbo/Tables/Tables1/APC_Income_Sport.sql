CREATE TABLE [dbo].[APC_Income_Sport] (
    [cd_conta_income]       INT          NOT NULL,
    [cd_mascara_conta]      VARCHAR (30) NOT NULL,
    [nm_conta_income]       VARCHAR (60) NULL,
    [ic_status_conta]       CHAR (1)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_conta_income_sport] INT          NOT NULL,
    [cd_conta]              INT          NULL,
    CONSTRAINT [PK_APC_Income_Sport] PRIMARY KEY CLUSTERED ([cd_conta_income] ASC),
    CONSTRAINT [FK_APC_Income_Sport_APC_Income] FOREIGN KEY ([cd_conta]) REFERENCES [dbo].[APC_Income] ([cd_conta_income])
);

