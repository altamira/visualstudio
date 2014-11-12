CREATE TABLE [dbo].[Lote_Contabil_Padrao] (
    [cd_empresa]               INT          NOT NULL,
    [cd_modulo]                INT          NOT NULL,
    [cd_departamento]          INT          NOT NULL,
    [cd_lote_contabil_padrao]  INT          NOT NULL,
    [ds_lote_contabil_padrao]  VARCHAR (40) NULL,
    [qt_inicial_lote_contabil] INT          NULL,
    [qt_final_lote_contabil]   INT          NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    CONSTRAINT [PK_Lote_contabil_padrao] PRIMARY KEY NONCLUSTERED ([cd_empresa] ASC, [cd_modulo] ASC, [cd_departamento] ASC, [cd_lote_contabil_padrao] ASC) WITH (FILLFACTOR = 90)
);

