CREATE TABLE [dbo].[Grupo_Ferramenta_Cam] (
    [cd_grupo_ferramenta]       INT      NOT NULL,
    [cd_sistema_cam]            INT      NOT NULL,
    [cd_ordem_grupo_ferram_cam] INT      NOT NULL,
    [cd_tipo_ferramenta_cam]    INT      NOT NULL,
    [cd_categoria_ferramenta]   INT      NOT NULL,
    [cd_ciclo_fixo_ferramenta]  INT      NOT NULL,
    [cd_usuario]                INT      NOT NULL,
    [dt_usuario]                DATETIME NOT NULL,
    CONSTRAINT [PK_Grupo_Ferramenta_Cam] PRIMARY KEY CLUSTERED ([cd_grupo_ferramenta] ASC, [cd_sistema_cam] ASC, [cd_tipo_ferramenta_cam] ASC, [cd_ciclo_fixo_ferramenta] ASC) WITH (FILLFACTOR = 90)
);

