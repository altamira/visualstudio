CREATE TABLE [dbo].[Parametro_Lote_Receber] (
    [cd_empresa]          INT      NOT NULL,
    [cd_tipo_documento]   INT      NULL,
    [cd_tipo_cobranca]    INT      NULL,
    [cd_plano_financeiro] INT      NULL,
    [cd_centro_custo]     INT      NULL,
    [cd_usuario]          INT      NULL,
    [dt_usuario]          DATETIME NULL,
    [ic_fluxo_caixa]      CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_Lote_Receber] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Lote_Receber_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
);

