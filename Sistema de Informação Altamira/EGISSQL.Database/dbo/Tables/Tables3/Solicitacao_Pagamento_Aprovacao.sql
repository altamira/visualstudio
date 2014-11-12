CREATE TABLE [dbo].[Solicitacao_Pagamento_Aprovacao] (
    [cd_solicitacao]       INT          NOT NULL,
    [cd_tipo_aprovacao]    INT          NOT NULL,
    [cd_usuario_aprovacao] INT          NOT NULL,
    [dt_usuario_aprovacao] DATETIME     NULL,
    [nm_obs_aprovacao]     VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_item_aprovacao]    INT          NULL,
    [ic_aprovado]          CHAR (1)     NULL,
    [cd_funcionario]       INT          NULL,
    CONSTRAINT [PK_Solicitacao_Pagamento_Aprovacao] PRIMARY KEY CLUSTERED ([cd_solicitacao] ASC, [cd_tipo_aprovacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Solicitacao_Pagamento_Aprovacao_Tipo_Aprovacao] FOREIGN KEY ([cd_tipo_aprovacao]) REFERENCES [dbo].[Tipo_Aprovacao] ([cd_tipo_aprovacao])
);

