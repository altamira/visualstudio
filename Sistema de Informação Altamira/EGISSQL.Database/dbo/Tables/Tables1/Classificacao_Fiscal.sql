CREATE TABLE [dbo].[Classificacao_Fiscal] (
    [cd_classificacao_fiscal]  INT          NOT NULL,
    [cd_mascara_classificacao] CHAR (10)    NULL,
    [nm_classificacao_fiscal]  VARCHAR (40) NULL,
    [sg_classificacao_fiscal]  CHAR (12)    NULL,
    [pc_ipi_classificacao]     FLOAT (53)   NULL,
    [ic_subst_tributaria]      CHAR (1)     NULL,
    [ic_base_reduzida]         CHAR (1)     NULL,
    [cd_dispositivo_legal]     INT          NULL,
    [cd_unidade_medida]        INT          NULL,
    [pc_importacao]            FLOAT (53)   NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [qt_siscomex_clas_fiscal]  FLOAT (53)   NULL,
    [ds_classificacao_fiscal]  TEXT         NULL,
    [ic_ativa_classificacao]   CHAR (1)     NULL,
    [cd_tributacao]            INT          NULL,
    [cd_dispositivo_legal_ipi] INT          NULL,
    [cd_especie_produto]       INT          NULL,
    [pc_ipi_entrada_classif]   FLOAT (53)   NULL,
    [cd_norma_origem]          INT          NULL,
    [cd_grupo_bem]             INT          NULL,
    [ic_licenca_importacao]    CHAR (1)     NULL,
    [ic_ipi_valor]             CHAR (1)     NULL,
    [vl_ipi_classificacao]     FLOAT (53)   NULL,
    [cd_extipi]                INT          NULL,
    [cd_genero_ncm_produto]    INT          NULL,
    [pc_subst_classificacao]   FLOAT (53)   NULL,
    [cd_genero]                INT          NULL,
    [ic_ipi_isento_zfm]        CHAR (1)     NULL,
    [ic_base_pis_clas_fiscal]  CHAR (1)     NULL,
    CONSTRAINT [PK_Classificacao_Fiscal] PRIMARY KEY CLUSTERED ([cd_classificacao_fiscal] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Classificacao_Fiscal_Grupo_Bem] FOREIGN KEY ([cd_grupo_bem]) REFERENCES [dbo].[Grupo_Bem] ([cd_grupo_bem]),
    CONSTRAINT [FK_Classificacao_Fiscal_Norma_Origem] FOREIGN KEY ([cd_norma_origem]) REFERENCES [dbo].[Norma_Origem] ([cd_norma_origem])
);


GO
CREATE NONCLUSTERED INDEX [ix_cd_mascara_classificacao]
    ON [dbo].[Classificacao_Fiscal]([cd_mascara_classificacao] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Classificacao_Fiscal]
    ON [dbo].[Classificacao_Fiscal]([cd_classificacao_fiscal] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Descricao]
    ON [dbo].[Classificacao_Fiscal]([nm_classificacao_fiscal] ASC) WITH (FILLFACTOR = 90);


GO
GRANT DELETE
    ON OBJECT::[dbo].[Classificacao_Fiscal] TO PUBLIC
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[Classificacao_Fiscal] TO PUBLIC
    AS [dbo];


GO
GRANT REFERENCES
    ON OBJECT::[dbo].[Classificacao_Fiscal] TO PUBLIC
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Classificacao_Fiscal] TO PUBLIC
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[Classificacao_Fiscal] TO PUBLIC
    AS [dbo];

