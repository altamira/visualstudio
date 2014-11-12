CREATE TABLE [dbo].[Classe_Tabsheet] (
    [cd_classe]   INT      NOT NULL,
    [cd_tabsheet] INT      NOT NULL,
    [cd_usuario]  INT      NULL,
    [dt_usuario]  DATETIME NULL,
    CONSTRAINT [PK_Classe_Tabsheet] PRIMARY KEY CLUSTERED ([cd_classe] ASC, [cd_tabsheet] ASC) WITH (FILLFACTOR = 90)
);

