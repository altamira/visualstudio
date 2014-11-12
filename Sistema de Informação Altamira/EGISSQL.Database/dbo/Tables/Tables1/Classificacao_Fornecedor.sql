CREATE TABLE [dbo].[Classificacao_Fornecedor] (
    [cd_classif_fornecedor]       INT          NOT NULL,
    [nm_classif_fornecedor]       VARCHAR (40) NULL,
    [sg_classif_fornecedor]       CHAR (10)    NULL,
    [qt_classif_fornecedor]       FLOAT (53)   NULL,
    [ic_ativo_classif_fornecedor] CHAR (1)     NULL,
    [nm_obs_classif_fornecedor]   VARCHAR (40) NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    CONSTRAINT [PK_Classificacao_Fornecedor] PRIMARY KEY CLUSTERED ([cd_classif_fornecedor] ASC) WITH (FILLFACTOR = 90)
);

