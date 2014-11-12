CREATE TABLE [dbo].[Documento_Pagar_Imposto] (
    [cd_documento_pagar]        INT           NOT NULL,
    [cd_imposto]                INT           NOT NULL,
    [cd_imposto_especificacao]  INT           NULL,
    [cd_receita_tributo]        INT           NULL,
    [cd_darf_codigo]            INT           NULL,
    [pc_imposto_documento]      FLOAT (53)    NULL,
    [nm_observacao_documento]   VARCHAR (120) NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [dt_competencia_apuracao]   DATETIME      NULL,
    [vl_principal_imposto]      FLOAT (53)    NULL,
    [vl_multa_imposto]          FLOAT (53)    NULL,
    [vl_juros_imposto]          FLOAT (53)    NULL,
    [cd_documento_pagar_gerado] INT           NULL,
    [dt_inicio_apuracao]        DATETIME      NULL,
    [dt_vencimento_imposto]     DATETIME      NULL,
    [dt_apuracao_imposto]       DATETIME      NULL,
    [dt_fato_gerador]           DATETIME      NULL,
    [vl_tributado_documento]    FLOAT (53)    NULL,
    CONSTRAINT [PK_Documento_Pagar_Imposto] PRIMARY KEY CLUSTERED ([cd_documento_pagar] ASC, [cd_imposto] ASC) WITH (FILLFACTOR = 90)
);

