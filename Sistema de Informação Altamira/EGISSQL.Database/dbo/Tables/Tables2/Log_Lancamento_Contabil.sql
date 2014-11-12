CREATE TABLE [dbo].[Log_Lancamento_Contabil] (
    [cd_empresa]             INT          NOT NULL,
    [cd_exercicio]           INT          NOT NULL,
    [cd_lote]                INT          NOT NULL,
    [cd_lancamento_contabil] INT          NOT NULL,
    [cd_log_lancamento]      INT          NOT NULL,
    [nm_log_lancamento]      VARCHAR (40) NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Log_lancamento_contabil] PRIMARY KEY NONCLUSTERED ([cd_empresa] ASC, [cd_exercicio] ASC, [cd_lote] ASC, [cd_lancamento_contabil] ASC, [cd_log_lancamento] ASC) WITH (FILLFACTOR = 90)
);

