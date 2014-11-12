CREATE TABLE [dbo].[Parametro_Folha] (
    [cd_empresa]                INT        NOT NULL,
    [ic_ponto_eletronico]       CHAR (1)   NULL,
    [ic_dsr_mes_referencia]     CHAR (1)   NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [ic_adto_funcionario]       CHAR (1)   NULL,
    [vl_arredondamento_empresa] FLOAT (53) NULL,
    [qt_dia_adto_empresa]       INT        NULL,
    [pc_adto_empresa]           FLOAT (53) NULL,
    [cd_modelo_recibo]          INT        NULL,
    [ic_micro_empresa]          CHAR (1)   NULL,
    [qt_hora_mes_folha]         FLOAT (53) NULL,
    [ic_tipo_geracao_scp]       CHAR (1)   NULL,
    [pc_13salario_parcela]      FLOAT (53) NULL,
    CONSTRAINT [PK_Parametro_Folha] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Folha_Modelo_Recibo] FOREIGN KEY ([cd_modelo_recibo]) REFERENCES [dbo].[Modelo_Recibo] ([cd_modelo_recibo])
);

