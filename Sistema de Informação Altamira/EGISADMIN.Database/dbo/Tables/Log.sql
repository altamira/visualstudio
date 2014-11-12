CREATE TABLE [dbo].[Log] (
    [cd_log]              INT      NOT NULL,
    [dt_inicio]           DATETIME NULL,
    [dt_final]            DATETIME NULL,
    [qt_tabelas_procs]    INT      NULL,
    [ds_atulizacao]       TEXT     NULL,
    [cd_usuario_atualiza] INT      NULL,
    [dt_atualiza]         DATETIME NULL,
    [ds_atualizacao]      TEXT     NULL,
    CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED ([cd_log] ASC) WITH (FILLFACTOR = 90)
);

