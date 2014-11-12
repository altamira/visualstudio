CREATE TABLE [dbo].[Parametro_Frota] (
    [cd_empresa]             INT        NOT NULL,
    [vl_km_empresa]          FLOAT (53) NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    [qt_km_aviso_troca_oleo] FLOAT (53) NULL,
    [cd_operacao_fiscal]     INT        NULL,
    [pc_icms_padrao]         FLOAT (53) NULL,
    CONSTRAINT [PK_Parametro_Frota] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Frota_Operacao_Fiscal] FOREIGN KEY ([cd_operacao_fiscal]) REFERENCES [dbo].[Operacao_Fiscal] ([cd_operacao_fiscal])
);

