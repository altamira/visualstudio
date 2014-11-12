CREATE TABLE [dbo].[Lote_Contabil_Movimento] (
    [cd_exercicio]            INT      NOT NULL,
    [cd_empresa]              INT      NOT NULL,
    [cd_modulo]               INT      NULL,
    [dt_inicio_lote_contabil] DATETIME NULL,
    [dt_final_lote_contabil]  DATETIME NULL,
    [ic_gerado_lote_contabil] CHAR (1) NULL,
    [ic_atualizado_lote]      CHAR (1) NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    [cd_lote]                 INT      NOT NULL,
    CONSTRAINT [PK_Lote_Contabil_Movimento] PRIMARY KEY CLUSTERED ([cd_exercicio] ASC, [cd_empresa] ASC, [cd_lote] ASC) WITH (FILLFACTOR = 90)
);

