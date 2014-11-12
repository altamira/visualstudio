CREATE TABLE [dbo].[Bordero_Desconto] (
    [cd_bordero_desconto]   INT        NOT NULL,
    [dt_bordero_desconto]   DATETIME   NULL,
    [cd_conta_banco]        INT        NULL,
    [qt_media_dias_bordero] FLOAT (53) NULL,
    [vl_total_bordero]      FLOAT (53) NULL,
    [vl_juros_bordero]      FLOAT (53) NULL,
    [vl_iof_bordero]        FLOAT (53) NULL,
    [vl_custo_bordero]      FLOAT (53) NULL,
    [vl_taxa_bordero]       FLOAT (53) NULL,
    [qt_documento_bordero]  INT        NULL,
    [vl_liquido_bordero]    FLOAT (53) NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    CONSTRAINT [PK_Bordero_Desconto] PRIMARY KEY CLUSTERED ([cd_bordero_desconto] ASC) WITH (FILLFACTOR = 90)
);

