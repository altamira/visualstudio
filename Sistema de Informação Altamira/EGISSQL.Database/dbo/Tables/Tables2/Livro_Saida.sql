CREATE TABLE [dbo].[Livro_Saida] (
    [cd_livro_saida]          INT          NOT NULL,
    [dt_inicio_livro_saida]   DATETIME     NULL,
    [dt_fim_livro_saida]      DATETIME     NULL,
    [qt_registro_livro_saida] INT          NULL,
    [nm_obs_livro_saida]      VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Livro_Saida] PRIMARY KEY CLUSTERED ([cd_livro_saida] ASC) WITH (FILLFACTOR = 90)
);

