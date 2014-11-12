CREATE TABLE [dbo].[Movimento_Acesso] (
    [cd_movimento_acesso] INT      NOT NULL,
    [dt_movimento_acesso] DATETIME NULL,
    [cd_usuario]          INT      NULL,
    [dt_usuario]          DATETIME NULL,
    CONSTRAINT [PK_Movimento_Acesso] PRIMARY KEY CLUSTERED ([cd_movimento_acesso] ASC) WITH (FILLFACTOR = 90)
);

