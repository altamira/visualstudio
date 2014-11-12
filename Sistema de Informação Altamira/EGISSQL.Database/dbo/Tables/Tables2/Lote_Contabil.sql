CREATE TABLE [dbo].[Lote_Contabil] (
    [cd_empresa]                INT        NOT NULL,
    [cd_exercicio]              INT        NOT NULL,
    [cd_lote]                   INT        NOT NULL,
    [dt_lote]                   DATETIME   NOT NULL,
    [vl_lote_debito]            FLOAT (53) NULL,
    [vl_lote_credito]           FLOAT (53) NULL,
    [qt_total_lancamento_lote]  INT        NULL,
    [ic_consistencia_lote]      CHAR (1)   NOT NULL,
    [vl_lote_debito_informado]  FLOAT (53) NULL,
    [vl_lote_credito_informado] FLOAT (53) NULL,
    [cd_usuario]                INT        NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL,
    [ic_ativa_lote]             CHAR (1)   NULL,
    [cd_tipo_contab_automatica] INT        NULL,
    [ic_gerado_automaticamente] CHAR (1)   NULL,
    CONSTRAINT [PK_Lote_contabil] PRIMARY KEY NONCLUSTERED ([cd_empresa] ASC, [cd_exercicio] ASC, [cd_lote] ASC) WITH (FILLFACTOR = 90)
);

