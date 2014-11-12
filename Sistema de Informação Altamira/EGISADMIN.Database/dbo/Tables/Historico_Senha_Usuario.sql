CREATE TABLE [dbo].[Historico_Senha_Usuario] (
    [dt_troca_senha]      DATETIME  NOT NULL,
    [cd_usuario]          INT       NOT NULL,
    [cd_senha_usuario]    CHAR (10) NULL,
    [cd_usuario_atualiza] INT       NULL,
    [dt_atualiza]         DATETIME  NULL,
    [dt_usuario]          DATETIME  NULL,
    CONSTRAINT [PK_Historico_Senha_Usuario] PRIMARY KEY CLUSTERED ([dt_troca_senha] ASC, [cd_usuario] ASC) WITH (FILLFACTOR = 90)
);

