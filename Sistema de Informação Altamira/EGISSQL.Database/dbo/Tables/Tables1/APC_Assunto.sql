CREATE TABLE [dbo].[APC_Assunto] (
    [cd_assunto]         INT          NOT NULL,
    [nm_assunto]         VARCHAR (60) NULL,
    [ds_assunto]         TEXT         NULL,
    [ic_ativo_assunto]   CHAR (1)     NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [cd_funcionario]     INT          NULL,
    [cd_ordem_assunto]   INT          NULL,
    [cd_conta]           INT          NULL,
    [ic_offbook_assunto] CHAR (1)     NULL,
    [ic_equity_assunto]  CHAR (1)     NULL,
    [cd_conta_balanco]   INT          NULL,
    [cd_conta_income]    INT          NULL,
    CONSTRAINT [PK_APC_Assunto] PRIMARY KEY CLUSTERED ([cd_assunto] ASC),
    CONSTRAINT [FK_APC_Assunto_APC_Balanco] FOREIGN KEY ([cd_conta_balanco]) REFERENCES [dbo].[APC_Balanco] ([cd_conta_balanco]),
    CONSTRAINT [FK_APC_Assunto_APC_Income] FOREIGN KEY ([cd_conta_income]) REFERENCES [dbo].[APC_Income] ([cd_conta_income]),
    CONSTRAINT [FK_APC_Assunto_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

