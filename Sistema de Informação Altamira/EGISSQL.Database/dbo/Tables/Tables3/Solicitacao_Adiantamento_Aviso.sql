CREATE TABLE [dbo].[Solicitacao_Adiantamento_Aviso] (
    [cd_solicitacao]       INT      NOT NULL,
    [dt_aviso_solicitacao] DATETIME NULL,
    [cd_usuario_aviso]     INT      NULL,
    [qt_aviso_solicitacao] INT      NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Solicitacao_Adiantamento_Aviso] PRIMARY KEY CLUSTERED ([cd_solicitacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Solicitacao_Adiantamento_Aviso_Solicitacao_Adiantamento] FOREIGN KEY ([cd_solicitacao]) REFERENCES [dbo].[Solicitacao_Adiantamento] ([cd_solicitacao])
);

