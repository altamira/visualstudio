CREATE TABLE [dbo].[Solicitacao_Extra] (
    [cd_solicitacao]       INT          NOT NULL,
    [dt_solicitacao]       DATETIME     NULL,
    [cd_funcionario]       INT          NOT NULL,
    [cd_motivo_extra]      INT          NULL,
    [dt_inicio_extra]      DATETIME     NULL,
    [dt_fim_extra]         DATETIME     NULL,
    [qt_solicitacao_extra] FLOAT (53)   NULL,
    [nm_obs_solicitacao]   VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Solicitacao_Extra] PRIMARY KEY CLUSTERED ([cd_solicitacao] ASC),
    CONSTRAINT [FK_Solicitacao_Extra_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

