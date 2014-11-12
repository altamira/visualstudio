CREATE TABLE [dbo].[Solicitacao_Adiantamento_Liberacao] (
    [cd_solicitacao]           INT          NOT NULL,
    [cd_item_liberacao]        INT          NOT NULL,
    [cd_funcionario]           INT          NULL,
    [dt_liberacao_solicitacao] DATETIME     NULL,
    [nm_obs_liberacao]         VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Solicitacao_Adiantamento_Liberacao] PRIMARY KEY CLUSTERED ([cd_solicitacao] ASC, [cd_item_liberacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Solicitacao_Adiantamento_Liberacao_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

