CREATE TABLE [dbo].[Versao] (
    [cd_versao]           INT           NOT NULL,
    [nm_versao]           VARCHAR (20)  NOT NULL,
    [sg_versao]           CHAR (10)     NULL,
    [ic_versao_ativa]     CHAR (1)      NULL,
    [nm_imagem_versao]    VARCHAR (100) NULL,
    [dt_liberacao_versao] DATETIME      NULL,
    [dt_previsao_versao]  DATETIME      NULL,
    [cd_usuario]          INT           NULL,
    [dt_usuario]          DATETIME      NULL,
    CONSTRAINT [PK_Versao] PRIMARY KEY CLUSTERED ([cd_versao] ASC) WITH (FILLFACTOR = 90)
);

