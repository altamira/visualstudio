CREATE TABLE [dbo].[Fornecedor_Iso] (
    [cd_fornecedor]            INT          NOT NULL,
    [dt_inicial_iso]           DATETIME     NOT NULL,
    [dt_final_iso]             DATETIME     NOT NULL,
    [qt_ponto_fornecedor_iso]  FLOAT (53)   NULL,
    [nm_obs_fornecedor_iso]    VARCHAR (40) NULL,
    [qt_nivelq_fornecedor_iso] FLOAT (53)   NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_tipo_avaliacao]        INT          NULL,
    [cd_classif_fornecedor]    INT          NULL,
    CONSTRAINT [PK_Fornecedor_Iso] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [dt_inicial_iso] ASC, [dt_final_iso] ASC) WITH (FILLFACTOR = 90)
);

