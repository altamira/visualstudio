CREATE TABLE [dbo].[Grupo_Usuario_Classe_Tabsheet] (
    [cd_grupo_usuario]     INT      NOT NULL,
    [cd_classe]            INT      NOT NULL,
    [cd_tabsheet]          INT      NOT NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    [ic_consulta_tabsheet] CHAR (1) NULL,
    [ic_mostra_tabsheet]   CHAR (1) NULL,
    CONSTRAINT [PK_Grupo_Usuario_Classe_Tabsheet] PRIMARY KEY CLUSTERED ([cd_grupo_usuario] ASC, [cd_classe] ASC, [cd_tabsheet] ASC) WITH (FILLFACTOR = 90)
);

