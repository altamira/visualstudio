CREATE TABLE [dbo].[Categoria_DIPI] (
    [cd_grupo_dipi]             INT          NOT NULL,
    [cd_categoria_dipi]         INT          NOT NULL,
    [nm_categoria_dipi]         VARCHAR (60) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_mascara_categoria_dipi] VARCHAR (10) NULL,
    CONSTRAINT [PK_Categoria_DIPI] PRIMARY KEY CLUSTERED ([cd_categoria_dipi] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Categoria_DIPI_Grupo_DIPI] FOREIGN KEY ([cd_grupo_dipi]) REFERENCES [dbo].[Grupo_DIPI] ([cd_grupo_dipi])
);

