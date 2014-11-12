CREATE TABLE [dbo].[Solicitacao_Pagamento_Confidencial] (
    [cd_solicitacao]              INT      NOT NULL,
    [ds_solicitacao_confidencial] TEXT     NULL,
    [cd_usuario]                  INT      NULL,
    [dt_usuario]                  DATETIME NULL,
    CONSTRAINT [PK_Solicitacao_Pagamento_Confidencial] PRIMARY KEY CLUSTERED ([cd_solicitacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Solicitacao_Pagamento_Confidencial_Solicitacao_Pagamento] FOREIGN KEY ([cd_solicitacao]) REFERENCES [dbo].[Solicitacao_Pagamento] ([cd_solicitacao])
);

