CREATE TABLE [dbo].[Produto_Grupo_Localizacao] (
    [cd_grupo_localizacao] INT          NOT NULL,
    [nm_grupo_localizacao] VARCHAR (40) NULL,
    [sg_grupo_localizacao] CHAR (15)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Produto_Grupo_Localizacao] PRIMARY KEY CLUSTERED ([cd_grupo_localizacao] ASC) WITH (FILLFACTOR = 90)
);

