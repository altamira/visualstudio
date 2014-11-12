CREATE TABLE [dbo].[Ferramenta_Corte_Padrao] (
    [cd_ferramenta]            INT        NOT NULL,
    [cd_mat_prima]             INT        NOT NULL,
    [vl_corte_ferramenta]      FLOAT (53) NULL,
    [vl_rotacao_ferramenta]    FLOAT (53) NULL,
    [vl_avancotrab_ferramenta] FLOAT (53) NULL,
    [vl_avancomerg_ferramenta] FLOAT (53) NULL,
    [vl_avanco_medio_fer]      FLOAT (53) NULL,
    [qt_vidautil_ferramenta]   FLOAT (53) NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    CONSTRAINT [PK_Ferramenta_Corte_Padrao] PRIMARY KEY CLUSTERED ([cd_ferramenta] ASC, [cd_mat_prima] ASC) WITH (FILLFACTOR = 90)
);

