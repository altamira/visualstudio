CREATE TABLE [dbo].[Lote_Cambio] (
    [cd_empresa]               INT        NOT NULL,
    [cd_lote]                  INT        NOT NULL,
    [dt_lote]                  DATETIME   NULL,
    [vl_lote_debito]           FLOAT (53) NULL,
    [vl_lote_credito]          FLOAT (53) NULL,
    [qt_total_lancamento_lote] INT        NULL,
    [ic_consistencia_lote]     CHAR (1)   NULL,
    [cd_usuario]               INT        NOT NULL,
    [dt_usuario]               DATETIME   NULL,
    CONSTRAINT [PK_Lote_Cambio] PRIMARY KEY NONCLUSTERED ([cd_empresa] ASC, [cd_lote] ASC) WITH (FILLFACTOR = 90)
);

