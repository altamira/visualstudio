CREATE TABLE [dbo].[SPED_Livro_Bloco] (
    [cd_livro]       INT      NOT NULL,
    [cd_bloco]       INT      NULL,
    [ic_bloco_ativo] CHAR (1) NULL,
    [cd_usuario]     INT      NULL,
    [dt_usuario]     DATETIME NULL,
    CONSTRAINT [PK_SPED_Livro_Bloco] PRIMARY KEY CLUSTERED ([cd_livro] ASC),
    CONSTRAINT [FK_SPED_Livro_Bloco_SPED_Bloco_Contabil] FOREIGN KEY ([cd_bloco]) REFERENCES [dbo].[SPED_Bloco_Contabil] ([cd_bloco])
);

