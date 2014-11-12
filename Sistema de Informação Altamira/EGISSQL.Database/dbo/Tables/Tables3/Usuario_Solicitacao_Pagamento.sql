CREATE TABLE [dbo].[Usuario_Solicitacao_Pagamento] (
    [cd_controle_usuario]          INT          NOT NULL,
    [cd_usuario_solicitacao]       INT          NOT NULL,
    [cd_senha_usuario_solicitacao] VARCHAR (10) NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    CONSTRAINT [PK_Usuario_Solicitacao_Pagamento] PRIMARY KEY CLUSTERED ([cd_controle_usuario] ASC, [cd_usuario_solicitacao] ASC) WITH (FILLFACTOR = 90)
);

