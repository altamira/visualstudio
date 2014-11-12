CREATE TABLE [dbo].[Livro_CIAP] (
    [cd_livro_ciap]          INT          NOT NULL,
    [dt_inicio_livro_ciap]   DATETIME     NULL,
    [dt_fim_livro_ciap]      DATETIME     NULL,
    [qt_registro_livro_ciap] INT          NULL,
    [nm_obs_livro_ciap]      VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Livro_CIAP] PRIMARY KEY CLUSTERED ([cd_livro_ciap] ASC) WITH (FILLFACTOR = 90)
);

