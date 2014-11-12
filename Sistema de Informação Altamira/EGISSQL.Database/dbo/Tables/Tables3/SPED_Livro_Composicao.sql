CREATE TABLE [dbo].[SPED_Livro_Composicao] (
    [cd_livro]       INT          NOT NULL,
    [cd_item_livro]  INT          NOT NULL,
    [nm_campo]       VARCHAR (16) NULL,
    [nm_desc_campo]  VARCHAR (50) NULL,
    [ic_tipo_campo]  CHAR (1)     NULL,
    [qt_campo]       INT          NULL,
    [qt_dec_campo]   INT          NULL,
    [qt_col_campo]   INT          NULL,
    [nm_obs_campo]   VARCHAR (60) NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    [ic_campo_total] CHAR (1)     NULL,
    CONSTRAINT [PK_SPED_Livro_Composicao] PRIMARY KEY CLUSTERED ([cd_livro] ASC, [cd_item_livro] ASC),
    CONSTRAINT [FK_SPED_Livro_Composicao_SPED_Livro] FOREIGN KEY ([cd_livro]) REFERENCES [dbo].[SPED_Livro] ([cd_livro])
);

