CREATE TABLE [dbo].[Parametro_Previsao_Venda] (
    [cd_empresa]             INT      NOT NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    [ic_conv_moeda_previsao] CHAR (1) NULL,
    [cd_moeda]               INT      NULL,
    [ic_demo_valor_previsao] CHAR (1) NULL,
    [ic_demo_perc_previsao]  CHAR (1) NULL,
    [ic_demo_custo_previsao] CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_Previsao_Venda] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Previsao_Venda_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

