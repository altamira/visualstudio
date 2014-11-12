CREATE TABLE [dbo].[Parametro_CIAP] (
    [cd_empresa]           INT        NOT NULL,
    [cd_operacao_fiscal]   INT        NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    [ic_demo_mes_completo] CHAR (1)   NULL,
    [ic_saldo_ciap]        CHAR (1)   NULL,
    [cd_local_bem]         INT        NULL,
    [qt_mes_ciap]          FLOAT (53) NULL,
    [sg_modelo_ciap]       CHAR (1)   NULL,
    [cd_tipo_movimento]    INT        NULL,
    CONSTRAINT [PK_Parametro_CIAP] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_CIAP_Local_Bem_Ciap] FOREIGN KEY ([cd_local_bem]) REFERENCES [dbo].[Local_Bem_Ciap] ([cd_local_bem]),
    CONSTRAINT [FK_Parametro_CIAP_Operacao_Fiscal] FOREIGN KEY ([cd_operacao_fiscal]) REFERENCES [dbo].[Operacao_Fiscal] ([cd_operacao_fiscal]),
    CONSTRAINT [FK_Parametro_CIAP_SPED_Tipo_Movimento_Bem] FOREIGN KEY ([cd_tipo_movimento]) REFERENCES [dbo].[SPED_Tipo_Movimento_Bem] ([cd_tipo_movimento])
);

