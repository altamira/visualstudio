CREATE TABLE [dbo].[Parametro_Exportacao] (
    [cd_empresa]                INT        NOT NULL,
    [cd_fase_produto]           INT        NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [ic_descricao_tecnica]      CHAR (1)   NULL,
    [ic_embarque_gera_SCR]      CHAR (1)   NULL,
    [ic_embarque_gera_fluxo]    CHAR (1)   NULL,
    [ic_embarque_gera_scp]      CHAR (1)   NULL,
    [vl_teto_exportacao_simp]   FLOAT (53) NULL,
    [ic_tipo_cab_relatorio]     CHAR (1)   NULL,
    [ic_telefone_documento]     CHAR (1)   NULL,
    [ic_pais_documento]         CHAR (1)   NULL,
    [qt_casa_decimal_documento] INT        NULL,
    [ic_proforma_invoice]       CHAR (1)   NULL,
    CONSTRAINT [PK_Parametro_Exportacao] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Exportacao_Fase_Produto] FOREIGN KEY ([cd_fase_produto]) REFERENCES [dbo].[Fase_Produto] ([cd_fase_produto])
);

