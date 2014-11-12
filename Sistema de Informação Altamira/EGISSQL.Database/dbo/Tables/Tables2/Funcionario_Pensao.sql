CREATE TABLE [dbo].[Funcionario_Pensao] (
    [cd_funcionario]           INT          NOT NULL,
    [cd_banco]                 INT          NULL,
    [nm_agencia_pensao]        VARCHAR (20) NULL,
    [nm_conta_pensao]          VARCHAR (20) NULL,
    [nm_favorecido_pensao]     VARCHAR (60) NULL,
    [cd_cpf_favorecido_pensao] VARCHAR (18) NULL,
    [dt_autorizacao_pensao]    DATETIME     NULL,
    [nm_obs_pensao]            VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Funcionario_Pensao] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC),
    CONSTRAINT [FK_Funcionario_Pensao_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

