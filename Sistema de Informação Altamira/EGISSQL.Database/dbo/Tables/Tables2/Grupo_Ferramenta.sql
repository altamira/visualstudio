CREATE TABLE [dbo].[Grupo_Ferramenta] (
    [cd_grupo_ferramenta] INT           NOT NULL,
    [nm_grupo_ferramenta] VARCHAR (40)  NULL,
    [sg_grupo_ferramenta] VARCHAR (15)  NULL,
    [ds_programacao_cnc]  TEXT          NULL,
    [im_grupo_ferramenta] VARCHAR (100) NULL,
    [cd_usuario]          INT           NOT NULL,
    [dt_usuario]          DATETIME      NULL,
    CONSTRAINT [PK__Grupo_Ferramenta__29221CFB] PRIMARY KEY CLUSTERED ([cd_grupo_ferramenta] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [XIF9Grupo_Ferramenta]
    ON [dbo].[Grupo_Ferramenta]([cd_usuario] ASC) WITH (FILLFACTOR = 90);

