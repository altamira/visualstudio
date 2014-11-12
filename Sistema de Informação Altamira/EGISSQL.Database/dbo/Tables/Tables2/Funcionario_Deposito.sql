CREATE TABLE [dbo].[Funcionario_Deposito] (
    [cd_funcionario]          INT          NOT NULL,
    [cd_banco]                INT          NULL,
    [nm_agencia_deposito]     VARCHAR (20) NULL,
    [nm_conta_deposito]       VARCHAR (20) NULL,
    [nm_favorecido_deposito]  VARCHAR (60) NULL,
    [cd_cpf_deposito]         VARCHAR (18) NULL,
    [dt_autorizacao_deposito] DATETIME     NULL,
    [nm_obs_deposito]         VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Funcionario_Deposito] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC),
    CONSTRAINT [FK_Funcionario_Deposito_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

