CREATE TABLE [dbo].[Grupo_Composicao] (
    [cd_grupo_composicao] INT          NOT NULL,
    [ds_grupo_composicao] VARCHAR (60) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Composicao] PRIMARY KEY CLUSTERED ([cd_grupo_composicao] ASC) WITH (FILLFACTOR = 90)
);

