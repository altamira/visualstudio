CREATE TABLE [dbo].[Usuario_Impressao] (
    [cd_usuario_impressao] INT           NOT NULL,
    [cd_usuario_acesso]    INT           NOT NULL,
    [nm_porta_impressao]   VARCHAR (100) NULL,
    [ic_porta_ativa]       CHAR (1)      NULL,
    [cd_usuario]           INT           NULL,
    [dt_usuario]           DATETIME      NULL,
    CONSTRAINT [PK_Usuario_Impressao] PRIMARY KEY CLUSTERED ([cd_usuario_impressao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Usuario_Impressao_Usuario] FOREIGN KEY ([cd_usuario_acesso]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

