CREATE TABLE [dbo].[Sessao_Arquivo_Detalhe] (
    [cd_usuario]                     INT      NULL,
    [dt_usuario]                     DATETIME NULL,
    [cd_sessao_Arquivo_detalhe]      INT      NOT NULL,
    [cd_sessao_arquivo_magnetiPai]   INT      NULL,
    [cd_sessao_arquivo_magnetiFilho] INT      NULL,
    CONSTRAINT [PK_Sessao_Arquivo_Detalhe] PRIMARY KEY CLUSTERED ([cd_sessao_Arquivo_detalhe] ASC) WITH (FILLFACTOR = 90)
);

