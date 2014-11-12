CREATE TABLE [dbo].[Prestacao_Conta_Liberacao] (
    [cd_prestacao]           INT          NOT NULL,
    [cd_item_liberacao]      INT          NOT NULL,
    [cd_funcionario]         INT          NULL,
    [dt_liberacao_prestacao] DATETIME     NULL,
    [nm_obs_liberacao]       VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Prestacao_Conta_Liberacao] PRIMARY KEY CLUSTERED ([cd_prestacao] ASC, [cd_item_liberacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Prestacao_Conta_Liberacao_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

