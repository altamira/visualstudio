CREATE TABLE [dbo].[Ferramenta_Mat_Prima] (
    [cd_ferramenta]             INT        NOT NULL,
    [cd_grupo_ferramenta]       INT        NOT NULL,
    [cd_mat_prima]              INT        NOT NULL,
    [vl_velocidade_corte_fer]   FLOAT (53) NOT NULL,
    [vl_avanco_faca_ferramenta] FLOAT (53) NOT NULL,
    [vl_avanco_ferramenta]      FLOAT (53) NOT NULL,
    [vl_rotacao_ferramenta]     FLOAT (53) NOT NULL,
    [cd_usuario]                INT        NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL,
    CONSTRAINT [PK_Ferramenta_Mat_Prima] PRIMARY KEY CLUSTERED ([cd_ferramenta] ASC, [cd_grupo_ferramenta] ASC, [cd_mat_prima] ASC) WITH (FILLFACTOR = 90)
);

