CREATE TABLE [dbo].[Usuario_Classe_TabSheet] (
    [cd_usuario]           INT      NOT NULL,
    [cd_classe]            INT      NOT NULL,
    [cd_tabsheet]          INT      NOT NULL,
    [dt_usuario]           DATETIME NULL,
    [ic_consulta_tabsheet] CHAR (1) NULL,
    [ic_mostra_tabsheet]   CHAR (1) NULL,
    CONSTRAINT [PK_Usuario_Classe_TabSheet] PRIMARY KEY CLUSTERED ([cd_usuario] ASC, [cd_classe] ASC, [cd_tabsheet] ASC) WITH (FILLFACTOR = 90)
);

