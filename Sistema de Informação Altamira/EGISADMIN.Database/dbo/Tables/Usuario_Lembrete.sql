CREATE TABLE [dbo].[Usuario_Lembrete] (
    [cd_processo_lembrete] INT      NOT NULL,
    [cd_usuario]           INT      NOT NULL,
    [dt_usuario]           DATETIME NULL,
    [dt_usuario_lembrete]  DATETIME NULL,
    CONSTRAINT [PK_Usuario_Lembrete] PRIMARY KEY CLUSTERED ([cd_processo_lembrete] ASC, [cd_usuario] ASC) WITH (FILLFACTOR = 90)
);

