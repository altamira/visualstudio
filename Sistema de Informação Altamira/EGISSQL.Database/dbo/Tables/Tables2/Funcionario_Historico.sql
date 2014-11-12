CREATE TABLE [dbo].[Funcionario_Historico] (
    [cd_funcionario_historico] INT          NOT NULL,
    [cd_funcionario]           INT          NOT NULL,
    [cd_alteracao_funcionario] INT          NULL,
    [dt_historico_funcionario] DATETIME     NULL,
    [nm_obs_historico]         VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Funcionario_Historico] PRIMARY KEY CLUSTERED ([cd_funcionario_historico] ASC, [cd_funcionario] ASC),
    CONSTRAINT [FK_Funcionario_Historico_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

