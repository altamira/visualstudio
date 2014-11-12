CREATE TABLE [dbo].[Livro_Entrada] (
    [cd_livro_entrada]          INT          NOT NULL,
    [dt_inicio_livro_entrada]   DATETIME     NULL,
    [dt_fim_livro_entrada]      DATETIME     NULL,
    [qt_registro_livro_entrada] INT          NULL,
    [nm_obs_livro_entrada]      VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Livro_Entrada] PRIMARY KEY CLUSTERED ([cd_livro_entrada] ASC) WITH (FILLFACTOR = 90)
);

