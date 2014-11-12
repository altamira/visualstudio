CREATE TABLE [dbo].[Bordero] (
    [cd_bordero]                INT        NOT NULL,
    [dt_emissao_bordero]        DATETIME   NULL,
    [dt_vencimento_bordero]     DATETIME   NULL,
    [dt_debito_bordero]         DATETIME   NULL,
    [qt_documento_bordero]      INT        NULL,
    [vl_total_documento_border] FLOAT (53) NULL,
    [ic_contabil_bordero]       CHAR (1)   NULL,
    [ic_baixado_bordero]        CHAR (1)   NULL,
    [dt_liquidacao_bordero]     DATETIME   NULL,
    [dt_inicial_bordero]        DATETIME   NULL,
    [dt_final_bordero]          DATETIME   NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [ic_tipo_bordero]           CHAR (1)   NULL,
    [ic_impresso]               CHAR (1)   NULL,
    CONSTRAINT [PK_Bordero] PRIMARY KEY CLUSTERED ([cd_bordero] ASC) WITH (FILLFACTOR = 90)
);

