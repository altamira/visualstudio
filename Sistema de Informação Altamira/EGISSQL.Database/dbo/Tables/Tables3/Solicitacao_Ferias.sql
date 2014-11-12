CREATE TABLE [dbo].[Solicitacao_Ferias] (
    [cd_solicitacao]           INT          NOT NULL,
    [dt_solicitacao]           DATETIME     NULL,
    [cd_funcionario]           INT          NOT NULL,
    [cd_opcao]                 INT          NOT NULL,
    [ic_13S_ferias]            CHAR (1)     NULL,
    [dt_inicio_g_ferias]       DATETIME     NULL,
    [dt_fim_g_ferias]          DATETIME     NULL,
    [nm_obs_solicitacao]       VARCHAR (40) NULL,
    [dt_aprovacao_solicitacao] DATETIME     NULL,
    [cd_usuario_aprovacao]     INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Solicitacao_Ferias] PRIMARY KEY CLUSTERED ([cd_solicitacao] ASC),
    CONSTRAINT [FK_Solicitacao_Ferias_Opcao_Ferias] FOREIGN KEY ([cd_opcao]) REFERENCES [dbo].[Opcao_Ferias] ([cd_opcao])
);

